import 'package:flutter/material.dart';
import 'package:noteflow/screens/auth/register_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NoteFlow',

      theme: ThemeData(
        useMaterial3: true,
      ),

      home: const RegisterScreen(),
    );
  }
}
