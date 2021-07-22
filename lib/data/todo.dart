
import 'package:flutter/material.dart';

class Todo{
  int id;
  int priority;
  String name;
  String description;
  String completedBy;

  Todo({@required this.name,@required this.description,@required this.completedBy,@required this.priority});
  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'priority': priority,
      'compeletedBy':completedBy,
      'description':description
    };
  }

 static Todo fromMap( Map<String, dynamic> map){
   return Todo(name:map['name'],
   description:map['description'],
   completedBy:map['completedBy'],
   priority: map['priority'], );
  }
}