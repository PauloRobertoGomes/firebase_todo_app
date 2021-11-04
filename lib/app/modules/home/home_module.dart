import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_todo_app/app/modules/home/repositories/todo_repository.dart';
import 'package:firebase_todo_app/app/modules/home/repositories/todo_repository_interface.dart';

import 'home_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'home_page.dart';

class HomeModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind<ITodoRepository>(
          (i) => TodoRepository(firestore: FirebaseFirestore.instance),
        ),
        Bind((i) => HomeController(i.get())),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => HomePage()),
      ];

  static Inject get to => Inject<HomeModule>.of();
}
