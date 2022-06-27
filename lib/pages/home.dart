import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:todos/models/models.dart';
import 'package:todos/models/ui_models.dart';

class Home extends StatefulWidget {
  static const String id = 'home';
  final User? user;
  const Home({Key? key, this.user}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Todo> todos = [];
  var finalText = '';
  final _database = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    _database.child('orders').onValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: const Text("ToDo"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: StreamBuilder(
          stream: _database.child('todos').onValue,
          builder: (context, AsyncSnapshot snapshot) {
            final todoList = <TodoTile>[];
            if (snapshot.hasData) {
              var event = snapshot.data! as Event;
              final todos = Map<String, dynamic>.from(event.snapshot.value);
              todos.forEach((key, value) {
                final nextTodo =
                    Todo.fromRTDB(Map<String, dynamic>.from(value));
                final todoTile = TodoTile(
                    todo: Todo(
                  path: nextTodo.path,
                  title: nextTodo.title,
                  isDone: nextTodo.isDone,
                  // timeStamp: nextTodo.timeStamp,
                ));
                todoList.add(todoTile);
              });
              return ListView(
                children: todoList,
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
      // backgroundColor: const Color.fromRGBO(29, 51, 84, 1),
      backgroundColor: const Color.fromRGBO(29, 112, 162, 1),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20.0))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Add Task',
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(fontSize: 25.0),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: TextField(
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline5,
                            decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 0.0)),
                            autofocus: true,
                            onChanged: (newText) {
                              finalText = newText;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: OutlinedButton(
                          clipBehavior: Clip.hardEdge,
                          child: Text('Done',
                              style: Theme.of(context)
                                  .textTheme
                                  .button!
                                  .copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 25)),
                          onPressed: () {
                            if (finalText.isNotEmpty) {
                              setState(() {
                                String id = _database.child('todos').push().key;
                                _database.child('todos').child(id).set({
                                  "title": finalText,
                                  "isDone": false,
                                  "id": id,
                                  // "timeStamp": DateTime.now()
                                });
                              });
                            }
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
