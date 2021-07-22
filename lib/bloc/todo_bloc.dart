import 'dart:async';

import 'package:ToDo/data/todo.dart';
import 'package:ToDo/data/todo_db.dart';
class TodoBloc {
  // 1. add a constructor
  TodoBloc(){
    db =TodoDb();
    getTodos();
    _todoInsertController.stream.listen(_addTodo);
    _todoUpdateController.stream.listen(_updateTodo);
    _todoDeleteController.stream.listen(_deleteTodo);
    _todosStreamController.stream.listen(returnTodos);
  }  
  // 2.Declaring the data that will change
  List<Todo> todoList;
  TodoDb db;
  //3.Setting the StreamControllers
  final _todosStreamController = StreamController<List<Todo>>.broadcast();
  final _todoInsertController = StreamController<Todo>();
  final _todoUpdateController = StreamController<Todo>();
  final _todoDeleteController = StreamController<Todo>();
  //4. Creating the getters for streams and sinks
  Stream<List<Todo>> get todos =>_todosStreamController.stream;
  StreamSink<List<Todo>> get todosSink => _todosStreamController.sink;
  StreamSink<Todo> get todoInsertSink => _todoInsertController.sink;
  StreamSink<Todo> get todoUpdateSink => _todoUpdateController.sink;
  StreamSink<Todo> get todoDeleteSink => _todoDeleteController.sink;

  //5. Adding the logic of the BLoC
  Future getTodos() async{
    List<Todo> todos = await db.getTodo();
    todoList = todos;
    todosSink.add(todos);
  }
  List<Todo> returnTodos (todos) {
    return todos;
  }
  void _deleteTodo(Todo todo){
    db.deleteTodo(todo).then((result) => getTodos());
  }
  void _updateTodo(Todo todo){
    db.updateTodo(todo).then((value) => getTodos());
  }
  void _addTodo(Todo todo){
    db.insertTodo(todo).then((value) => getTodos());
  }
  //in the dispose method we need to close the stream controllers.
  void dispose() {
  _todosStreamController.close();
  _todoInsertController.close();
  _todoUpdateController.close();
  _todoDeleteController.close();
  }
}