import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/todo_service.dart';

// Enum ini harus ada di luar class agar bisa dipanggil di file lain
enum Filter { all, completed, incomplete }

class TodoProvider extends ChangeNotifier {
  final TodoService _service = TodoService();
  List<Todo> _todos = [];
  Filter _filter = Filter.all;

  // Getter untuk Filter agar bisa diakses UI
  Filter get filter => _filter;
  List<Todo> get todos {
    switch (_filter) { 
      case Filter.completed:
        return _todos.where((todo) => todo.isCompleted).toList();
      case Filter.incomplete:
        return _todos.where((todo) => !todo.isCompleted).toList();
      case Filter.all:
      default:
        return _todos;
    } 
  }
  // ----------------------------------

  Future<void> init() async {
    _todos = await _service.loadTodos();
    notifyListeners();
  }

  void setFilter(Filter newFilter) {
    _filter = newFilter;
    notifyListeners();
  }

  void addTodo(String title) {
    _todos.add(Todo(
      id: DateTime.now().toString(),
      title: title,
      createdAt: DateTime.now(),
    ));
    _saveAndNotify();
  }

  void updateTodo(String id, String newTitle) {
    final index = _todos.indexWhere((e) => e.id == id);
    if (index != -1) {
      _todos[index].title = newTitle;
      _saveAndNotify();
    }
  }

  void toggleTodoStatus(String id) {
    final index = _todos.indexWhere((e) => e.id == id);
    if (index != -1) {
      _todos[index].isCompleted = !_todos[index].isCompleted;
      _saveAndNotify();
    }
  }

  void deleteTodo(String id) {
    _todos.removeWhere((e) => e.id == id);
    _saveAndNotify();
  }

  void _saveAndNotify() {
    _service.saveTodos(_todos);
    notifyListeners();
  }
}