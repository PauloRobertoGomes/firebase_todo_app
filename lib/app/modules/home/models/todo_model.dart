import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String title;
  bool check;
  final DocumentReference reference;

  TodoModel({this.title, this.check, this.reference});

  factory TodoModel.fromDocument(DocumentSnapshot doc) {
    return TodoModel(
      title: doc['title'],
      check: doc['check'],
      reference: doc.reference,
    );
  }
}
