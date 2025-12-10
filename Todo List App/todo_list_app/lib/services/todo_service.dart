import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

class TodoService {
  static const String _key = 'todos';

  Future<List<Todo>> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todosString = prefs.getString(_key);
    
    if (todosString != null) {
      // Pastikan decoded dianggap sebagai List
      List<dynamic> decoded = jsonDecode(todosString); 
      return decoded.map((model) => Todo.fromJson(model)).toList();
    }
    return [];
  }

  Future<void> saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(todos.map((e) => e.toJson()).toList());
    await prefs.setString(_key, encodedData);
  }
}