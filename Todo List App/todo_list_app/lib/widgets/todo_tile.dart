import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';
import '../screens/todo_edit_screen.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;

  const TodoTile({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: todo.isCompleted,
        onChanged: (_) {
          // Panggil fungsi toggle di provider
          Provider.of<TodoProvider>(context, listen: false)
              .toggleTodoStatus(todo.id);
        },
      ),
      title: Text(
        todo.title,
        style: TextStyle(
          decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
          color: todo.isCompleted ? Colors.grey : Colors.black,
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete, color: Colors.red),
        onPressed: () {
          Provider.of<TodoProvider>(context, listen: false).deleteTodo(todo.id);
        },
      ),
      onTap: () {
        // Navigasi ke layar Edit
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TodoEditScreen(todo: todo),
          ),
        );
      },
    );
  }
}