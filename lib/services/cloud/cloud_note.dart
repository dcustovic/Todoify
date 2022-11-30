import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_flutter/services/cloud/cloud_storage_constants.dart';

@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String text;
  final String? description;
  final Timestamp? date;
  final bool? completed;

  const CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
    required this.description,
    required this.date,
    required this.completed,
  });

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        text = snapshot.data()[textFieldName],
        description = snapshot.data()[descriptionFieldName],
        date = snapshot.data()[dateFieldName],
        completed = snapshot.data()[completedFieldName];
}
