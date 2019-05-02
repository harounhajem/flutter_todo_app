import 'package:flutter/material.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/util/dbhelper.dart';
import 'dart:math';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TodoListState();
}

class TodoListState extends State {
  DbHelper _helper = DbHelper();
  List<Todo> _todos;
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    if (_todos == null) {
      _todos = List<Todo>();
      getData();
    }
    return Scaffold(
        body: todoListItems(),
        floatingActionButton: FloatingActionButton(
            onPressed: null,
            tooltip: "Add new Todo",
            child: Icon(Icons.add_circle_outline)));
  }

  void getData() {
    final dbFuture = _helper.initilizeDatabase();
    dbFuture.then((result) {
      final todoFuture = _helper.getTodos();
      todoFuture.then((result) {
        List<Todo> todoList = new List<Todo>();
        int count = result.length;
        result.forEach((item) {
          todoList.add(Todo.fromObject(item));
          debugPrint(todoList.last.title.toString());
        });
        setState(() {
          todoList.sort((a, b) => a.priority.compareTo(b.priority));
          _todos = todoList;
          _count = count;
          debugPrint("Items $count");
        });
      });
    });
  }

  ListView todoListItems() {
    return ListView.builder(
        itemCount: _count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.red,
                child: Text(this._todos[position].priority.toString()),
              ),
              title: Text(this._todos[position].title),
              subtitle: Text(this._todos[position].date),
              onTap: () {
                String ran = Random.secure().nextInt(6000).toString();
                debugPrint("Tap $ran");
              },
            ),
          );
        });
  }
}
