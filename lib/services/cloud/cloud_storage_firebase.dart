import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_flutter/services/cloud/cloud_note.dart';
import 'package:notes_flutter/services/cloud/cloud_storage_constants.dart';
import 'package:notes_flutter/services/cloud/cloud_storage_exceptions.dart';

class CloudStorageFirebase {
  // creating a singleton
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
            (value) => value.docs.map(
              (doc) => CloudNote(
                documentId: doc.id,
                ownerUserId: doc.data()[ownerUserIdFieldName],
                text: doc.data()[textFieldName],
              ),
            ),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  void createNewNote({required ownerId}) async {
    await notes.add(
      {
        ownerUserIdFieldName: ownerId,
        textFieldName: '',
      },
    );
  }
}
