import 'package:flutter/material.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/util/dbhelper.dart';
import 'package:intl/intl.dart';

DbHelper dbHelper = DbHelper();

final List<String> choices = const <String>[
  'Save Todo & Back',
  'Delete todo',
  'Back to List'
];

const mnuSave = 'Save Todo & Back';
const mnuDelete = 'Delete todo';
const mnuBack = 'Back to List';

class TodoDetails extends StatefulWidget {
  final Todo todo;
  TodoDetails(this.todo);

  @override
  TodoDetailsState createState() => TodoDetailsState(todo);
}

class TodoDetailsState extends State {
  Todo todo;
  TodoDetailsState(this.todo);
  final _priorites = ['High', 'Medium', 'Low', 'Forget'];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = todo.title;
    descriptionController.text = todo.description;

    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(todo.title),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: (value) => select(value),
              itemBuilder: (BuildContext context) {
                return choices.map((String choice) {
                  return PopupMenuItem<String>(
                      value: choice, child: Text(choice));
                }).toList();
              },
            )
          ],
        ),
        body: Padding(
            padding: EdgeInsets.only(top: 35, left: 10, right: 10),
            child: ListView(children: <Widget>[
              Column(
                children: <Widget>[
                  TextField(
                      controller: titleController,
                      style: textStyle,
                      onChanged: (value) => updateTitle(),
                      decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                  width: 6, style: BorderStyle.solid)))),
                  Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      child: TextField(
                          controller: descriptionController,
                          style: textStyle,
                          onChanged: (value) => this.updateDescription(),
                          decoration: InputDecoration(
                              labelText: 'Description',
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      width: 6, style: BorderStyle.solid))))),
                  ListTile(
                      title: DropdownButton<String>(
                          style: textStyle,
                          value: retrievePriority(todo.priority),
                          hint: new Text('Please select value'),
                          items: _priorites.map((String value) {
                            return DropdownMenuItem<String>(
                                value: value, child: new Text(value));
                          }).toList(),
                          onChanged: (value) => updatePriority(value)))
                ],
              )
            ])));
  }

  void select(String selected) async {
    int result;

    switch (selected) {
      case mnuBack:
        Navigator.pop(context, true);
        break;

      case mnuDelete:
        Navigator.pop(context, true);
        if (todo.id == null) {
          return;
        }
        result = await dbHelper.deleteTodo(todo);
        if (result != 0) {
          AlertDialog alertDialog = AlertDialog(
              title: Text("Delete todo"),
              content: Text("The todo has been deleted"));
          showDialog(context: context, builder: (_) => alertDialog);
        }
        break;

      case mnuSave:
        save();
        break;

      default:
        debugPrint("None selected");
        break;
    }
    switch (selected) {
    }
  }

  void save() async {
    todo.date = new DateFormat.yMd().format(DateTime.now());
    if (todo.id != null) {
      dbHelper.updateTodo(todo);
    } else {
      dbHelper.insertTodo(todo);
    }
    Navigator.pop(context, true);
  }

  void updatePriority(String value) {
    switch (value) {
      case "High":
        todo.priority = 1;
        break;
      case "Medium":
        todo.priority = 2;
        break;
      case "Low":
        todo.priority = 3;
        break;
      case "Forget":
        todo.priority = 4;
        break;
      default:
        debugPrint("No prio found");
        break;
    }
    setState(() {});
  }

  String retrievePriority(int value) {
    return _priorites[value - 1];
  }

  void updateTitle() {
    todo.title = titleController.text;
  }

  void updateDescription() {
    todo.description = descriptionController.text;
  }
}
