import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/todo_screen.dart';
import 'providers/todo_provider.dart';

void main() {
  runApp(const MyApp()); // Tambahkan const jika diminta
}

class MyApp extends StatelessWidget {
  // Tambahkan constructor ini agar warning hilang
  const MyApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodoProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Praktikum Todo List',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const TodoScreen(), // Tambahkan const jika diminta
      ),
    );
  }
}