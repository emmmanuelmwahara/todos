// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todos/models/models.dart';

class TodoTile extends StatefulWidget {
  final Todo todo;
  const TodoTile({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  State<TodoTile> createState() => _TodoTileState();
}

class _TodoTileState extends State<TodoTile> {
  late bool tempDone;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
      child: CheckboxListTile(
        value: widget.todo.isDone,
        onChanged: (bool? value) {
          setState(() {
            // _checked = value!;
            widget.todo.toggleIsDone();
          });
        },
        title: Text(
          widget.todo.title!,
          style: TextStyle(
            color: widget.todo.isDone ? Colors.green : Colors.white,
            fontSize: 22,
            decoration: widget.todo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        // tileColor: const Color.fromRGBO(109, 174, 219, 1),
        tileColor: const Color.fromRGBO(29, 51, 84, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
