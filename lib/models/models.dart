//models

import 'package:firebase_database/firebase_database.dart';

class Todo {
  final String? title;
  String path;
  bool isDone;
  // final DateTime timeStamp;

  Todo({
    required this.title,
    // required this.timeStamp,
    this.isDone = false,
    required this.path,
  });

  factory Todo.fromRTDB(Map<String, dynamic> data) {
    return Todo(
      title: data['title'] ?? 'some task',
      isDone: data['isDone'] ?? false,
      path: data['id'],
      // timeStamp: (data['time'] != null)
      //     ? DateTime.fromMillisecondsSinceEpoch(data['time'])
      //     : DateTime.now()
    );
  }

  void toggleIsDone() {
    // print(path);
    isDone = !isDone;
    FirebaseDatabase.instance.reference().child('todos').child(path).update({
      "isDone": isDone,
    });
  }
}
