import 'package:ToDo/bloc/todo_bloc.dart';
import 'package:ToDo/data/todo.dart';
import 'package:ToDo/data/todo_db.dart';
import 'package:flutter/material.dart';

import 'data/todo_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  testDb() async{
    TodoDb db = TodoDb();
    await db.database;
    List<Todo> todos = await db.getTodo();
    await db.deleteAll();
    todos = await db.getTodo();
    await db.insertTodo(Todo(name:'Call Donald', description :'And tell him about Daisy',
    completedBy: '02/02/2020',priority :1));
    await db.insertTodo(Todo(name:'Buy Sugar',  description :'1 Kg, brown',completedBy:'02/02/2020',
    priority :2));
    await db.insertTodo(Todo(name:'Go Running', description : '@12.00, with neighbours',
    completedBy:'02/02/2020', priority :3));
    todos = await db.getTodo();
    debugPrint("first Insert");
    todos.forEach((element) {print(element.name);});
    Todo toDoToUpdate = todos[0];
    toDoToUpdate.name = "Eiad Badr";
    db.updateTodo(toDoToUpdate);
   // todos = await db.getTodo();
    debugPrint("After update");
    todos.forEach((element) {print(element.name);});
    
  }
  TodoBloc todoBloc;
  List<Todo> todos;
  @override
  void initState() {
    todoBloc = TodoBloc();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Todo todo = Todo(name: '', description: '', priority: 0, completedBy: '');
    todos = todoBloc.todoList;
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDo app"),
      ),
      body: Container(
        child: StreamBuilder(
          initialData: todos,
          stream: todoBloc.todos,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            return ListView.builder(itemCount: (snapshot.hasData? snapshot.data.length:0),
            itemBuilder: (ctx , index){
              return Dismissible(key: Key(snapshot.data[index].id.toString()),
                onDismissed: (_)=> todoBloc.todoDeleteSink.add(snapshot.data[index]), 
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).highlightColor,
                    child: Text("${snapshot.data[index].priority}"),),
                  title: Text("${snapshot.data[index].name}"),
                  subtitle: Text("${snapshot.data[index].description}"),
                  trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => TodoScreen(
                        snapshot.data[index], false)),
                        );
                        },
                        ),
                ));
            });
          }),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> TodoScreen(todo,true)));
        }),
    );
  }

  @override
  void dispose() {
    todoBloc.dispose();
    super.dispose();
  }
}
