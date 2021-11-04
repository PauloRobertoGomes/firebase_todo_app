import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/todo_model.dart';
import 'todo_repository_interface.dart';

class TodoRepository implements ITodoRepository {
  final FirebaseFirestore firestore;

  TodoRepository({this.firestore});

  @override
  Stream<List<TodoModel>> getTodos() {
    return firestore
        .collection('todo')
        .orderBy("position")
        .snapshots()
        .map((query) {
      return query.docs.map((doc) {
        return TodoModel.fromDocument(doc);
      }).toList();
    });
  }
}
