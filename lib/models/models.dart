//models

class Todo {
  final String? title;
  bool isDone;
  final int id = val;
  final DateTime? timeStamp;
  static int val = 0;

  Todo({
    required this.title,
    this.timeStamp,
    this.isDone = false,
  }) {
    val++;
    print(val);
  }

  factory Todo.fromRTDB(Map<String, dynamic> data) {
    return Todo(
        title: data['title'],
        isDone: data['isDone'],
        timeStamp: data['timestamp']);
  }
  void toggleIsDone() {
    isDone = !isDone;
  }
}
