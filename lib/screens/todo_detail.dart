import 'package:flutter/material.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/util/dbhelper.dart';
import 'package:intl/intl.dart';

class TodoDetails extends StatefulWidget {
  final Todo todo;
  TodoDetails(this.todo);

  @override
  TodoDetailsState createState() => TodoDetailsState(todo);
}

class TodoDetailsState extends State {
  Todo todo;
  TodoDetailsState(this.todo);
  String _priority = 'Low';
  final priorites = ['High', 'Medium', 'Low', 'None', 'Forget'];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = todo.title;
    descriptionController.text = todo.description;

    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
        appBar:
            AppBar(automaticallyImplyLeading: false, title: Text(todo.title)),
        body: Padding(
            padding: EdgeInsets.only(top: 35, left: 10, right: 10),
            child: ListView(children: <Widget>[
              Column(
                children: <Widget>[
                  TextField(
                      controller: titleController,
                      style: textStyle,
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
                          value: 'Low',
                          hint: new Text('Please select value'),
                          items: priorites.map((String value) {
                            return DropdownMenuItem<String>(
                                value: value, child: new Text(value));
                          }).toList(),
                          onChanged: (_) {}))
                ],
              )
            ])));
  }
}
