import 'dart:async';

import 'package:counterapp/database.dart';
import 'package:counterapp/dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:counterapp/todo_tile.dart';
import 'package:hive/hive.dart';


class HomePage extends StatefulWidget {
  
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  final _myBox = Hive.box('myBox');
  toDoDatabase db = toDoDatabase();


  @override
  void initState(){
    super.initState();
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    }
    else{
      db.loadData();
    }
  }


  final _controller = TextEditingController();

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  void checkBoxChanged(bool? value,int index){
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  void saveNewTask(){
    setState(() {
      db.toDoList.add([_controller.text,false]);
      _controller.clear();
    });
    db.updateDataBase();
    Navigator.of(context).pop();
  }

  void deleteTask(int index){
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  void createNewTask(){
    setState(() {
      showDialog(
        context:context, 
        builder:(context){
          return DialogBox(
            controller: _controller,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop(),
          );
        }
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("ToDo"),
        elevation: 20,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
        ),
      body:ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context,index){
          return ToDoTile(
            taskName: db.toDoList[index][0], 
            taskCompleted: db.toDoList[index][1], 
            onChanged:(value) => checkBoxChanged(value,index),
            deleteFunction: (context) => deleteTask(index),
          );
        }
      )
    );
  }
}