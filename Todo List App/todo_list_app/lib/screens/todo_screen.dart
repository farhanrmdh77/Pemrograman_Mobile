import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart'; // Filter diambil dari sini
import '../widgets/todo_tile.dart';
import 'todo_edit_screen.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  void initState() {
    super.initState();
    // Gunakan Microtask agar tidak error saat build belum selesai
    Future.microtask(() => 
      Provider.of<TodoProvider>(context, listen: false).init()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List App'),
        actions: [
          Consumer<TodoProvider>(
            builder: (context, provider, _) => PopupMenuButton<Filter>(
              initialValue: provider.filter,
              onSelected: (Filter item) {
                provider.setFilter(item);
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Filter>>[
                const PopupMenuItem(value: Filter.all, child: Text('Semua')),
                const PopupMenuItem(value: Filter.completed, child: Text('Selesai')),
                const PopupMenuItem(value: Filter.incomplete, child: Text('Belum Selesai')),
              ],
            ),
          ),
        ],
      ),
      body: Consumer<TodoProvider>(
        builder: (context, provider, child) {
          final todos = provider.todos;
          
          if (todos.isEmpty) {
            return const Center(child: Text('Tidak ada data.'));
          }

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              return TodoTile(todo: todos[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const TodoEditScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}