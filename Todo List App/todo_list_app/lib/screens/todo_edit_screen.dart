import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';

class TodoEditScreen extends StatefulWidget {
  final Todo? todo;

  const TodoEditScreen({Key? key, this.todo}) : super(key: key);

  @override
  _TodoEditScreenState createState() => _TodoEditScreenState();
}

class _TodoEditScreenState extends State<TodoEditScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      _controller.text = widget.todo!.title;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.todo != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Todo' : 'Tambah Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Judul Kegiatan',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                if (_controller.text.isEmpty) return;

                final provider = Provider.of<TodoProvider>(context, listen: false);
                
                if (isEditing) {
                  provider.updateTodo(widget.todo!.id, _controller.text);
                } else {
                  provider.addTodo(_controller.text);
                }

                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}