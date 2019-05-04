import 'package:flutter/material.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/util/dbhelper.dart';
import 'package:todo_app/screens/todo_detail.dart';
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
            onPressed: () {
              navigateDetail(Todo('', 3, '', ''));
            },
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
                backgroundColor: getColor(this._todos[position].priority),
                child: Text(this._todos[position].priority.toString(),
                    style: TextStyle(color: Color(0xFF000000))),
              ),
              title: Text(this._todos[position].title),
              subtitle: Text(this._todos[position].date),
              onTap: () {
                debugPrint(
                    "Tap item ${this._todos[position].id.toString()}, ${Random.secure().nextInt(6000).toString()}");
                navigateDetail(this._todos[position]);
              },
            ),
          );
        });
  }

  Color getColor(int prio) {
    switch (prio) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.lime;
      case 5:
        return Colors.green;
      default:
        return Colors.white;
    }
  }

  void navigateDetail(Todo todo) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => TodoDetails(todo)));
    if (result) {
     getData();
    }
  }
}
