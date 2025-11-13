import 'package:hive_flutter/hive_flutter.dart';

class toDoDatabase {
  List toDoList = [];
  
  final _myBox = Hive.box('myBox');
  
  void createInitialData(){
    toDoList = [
      ["Make Tutorial",false],
      ["Do Excercise",false]
    ];
    updateDataBase();
  }

  void loadData(){
    toDoList = _myBox.get("TODOLIST");

  }

  void updateDataBase(){
    _myBox.put("TODOLIST", toDoList);

  }
}