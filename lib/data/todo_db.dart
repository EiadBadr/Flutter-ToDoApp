import 'package:ToDo/data/todo.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class TodoDb{
  //this needs to be a singleton
  static final TodoDb _singleton = TodoDb._internal();
  //private internal constructor
  TodoDb._internal();
  factory TodoDb(){return _singleton;}
  DatabaseFactory dbFactory = databaseFactoryIo; //databaseFactory used to open sembast Database
  final store = intMapStoreFactory.store('todos'); // this to create store inside database (like folder)
  Database _database;
  Future<Database> get database async{
    if (_database == null){
     await _openDb().then((db){
       _database = db;
     });
     return _database;
    }
  }
  Future _openDb() async{
  final docsPath = await getApplicationDocumentsDirectory();
  final dbPath = join(docsPath.path, 'todos.db');
  final db = await dbFactory.openDatabase(dbPath);
  return db;
  }
  Future insertTodo(Todo toDo) async{
    await store.add(_database, toDo.toMap());
  }
  Future updateTodo(Todo toDo) async{
    final finder = Finder(filter: Filter.byKey(toDo.id));
    await store.update(_database, toDo.toMap(), finder: finder);
  }
  Future deleteTodo(Todo toDo) async{
    final finder = Finder(filter: Filter.byKey(toDo.id));
    await store.delete(_database,  finder: finder);
  }
  Future deleteAll() async{
    await store.delete(_database);
  }
  Future<List<Todo>> getTodo() async{
    await database;
    final finder = Finder(sortOrders: [SortOrder('priority'), SortOrder('id')]);
    final todosSnapshot = await store.find(_database, finder: finder);
    return todosSnapshot.map((snapshot){
      final todo = Todo.fromMap(snapshot.value);
      //the id is automatically generated
      todo.id = snapshot.key;
      return todo;
    }).toList();
  }
}