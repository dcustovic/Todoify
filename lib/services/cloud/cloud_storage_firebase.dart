import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_flutter/services/cloud/cloud_note.dart';
import 'package:notes_flutter/services/cloud/cloud_storage_constants.dart';
import 'package:notes_flutter/services/cloud/cloud_storage_exceptions.dart';

class CloudStorageFirebase {
  // creating a singleton - not creating new instances altho it looks like it
  static final CloudStorageFirebase _shared =
      CloudStorageFirebase._sharedInstance();
  CloudStorageFirebase._sharedInstance();
  factory CloudStorageFirebase() => _shared;

  final notes = FirebaseFirestore.instance.collection('notes');

  Future<void> deleteNote({required documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote({required documentId, required text}) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required ownerUserId}) {
    return notes.snapshots().map(
          (snapshots) => snapshots.docs
              .map(
                (doc) => CloudNote.fromSnapshot(doc),
              )
              .where((note) => note.ownerUserId == ownerUserId),
        );
  }

  Future<Iterable<CloudNote>> getNotes({required ownerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map((doc) => CloudNote.fromSnapshot(doc)),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Future<CloudNote> createNewNote({required ownerId}) async {
    final document = await notes.add(
      {
        ownerUserIdFieldName: ownerId,
        textFieldName: '',
      },
    );
    final data = await document.get();
    return CloudNote(documentId: data.id, ownerUserId: ownerId, text: '');
  }
}
