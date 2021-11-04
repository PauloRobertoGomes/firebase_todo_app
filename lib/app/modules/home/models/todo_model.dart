import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String title;
  bool check;
  DocumentReference reference;

  TodoModel({this.title = "", this.check = false, this.reference});

  factory TodoModel.fromDocument(DocumentSnapshot doc) {
    return TodoModel(
      title: doc['title'],
      check: doc['check'],
      reference: doc.reference,
    );
  }

  Future save() async {
    if (reference == null) {
      int total = (await FirebaseFirestore.instance.collection('todo').get())
          .docs
          .length;
      reference = await FirebaseFirestore.instance.collection("todo").add(
        {"title": title, "check": check, "position": total},
      );
    } else {
      reference.update({"title": title, "check": check});
    }
  }

  Future delete() {
    return reference.delete();
  }
}
