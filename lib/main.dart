import 'package:ejemplo/screens/auth_screen.dart';
import 'package:flutter/material.dart';
// import 'package:ejemplo/screens/login_screen.dart';

void main() {
  runApp(EjemploApp());
}

class EjemploApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ejemplo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthScreen(),
    );
  }
}
