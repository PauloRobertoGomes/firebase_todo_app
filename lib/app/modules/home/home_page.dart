import 'package:firebase_todo_app/app/modules/home/models/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'home_controller.dart';
import 'package:firebase_core/firebase_core.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeController> {
  //use 'controller' variable to access controller

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Observer(
        builder: (_) {
          if (controller.todoList.data == null) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      text: "Buscando afazeres",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ],
              ),
            );
          } else if (controller.todoList.hasError) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 50,
                  ),
                  SizedBox(height: 15),
                  RichText(
                    text: TextSpan(
                      text: "Ocorreu um erro ao buscar os produtos",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  SizedBox(height: 10),
                  RaisedButton(
                    onPressed: () => controller.getList(),
                    child: Text(
                      "Tentar Novamente",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Theme.of(context).accentColor,
                  ),
                ],
              ),
            );
          } else {
            List<TodoModel> list = controller.todoList.data;
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                TodoModel model = list[index];
                return ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      model.delete();
                    },
                  ),
                  title: Text(model.title),
                  onTap: () {
                    _showDialog(model);
                  },
                  trailing: Checkbox(
                    value: model.check,
                    onChanged: (check) {
                      model.check = check;
                      model.save();
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  _showDialog([TodoModel newModel]) {
    newModel ??= TodoModel();
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(newModel.title.isEmpty
              ? "Adicionar novo afazer"
              : "Editar afazer"),
          content: TextFormField(
            initialValue: newModel.title,
            onChanged: (value) => newModel.title = value,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Titulo do afazer",
            ),
          ),
          actions: [
            FlatButton(
              onPressed: () {
                Modular.to.pop();
              },
              child: Text("Cancelar"),
            ),
            FlatButton(
              onPressed: () async {
                newModel.save();
                Modular.to.pop();
              },
              child: Text("Salvar"),
            ),
          ],
        );
      },
    );
  }
}
