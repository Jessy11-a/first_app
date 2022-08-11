import 'package:flutter/material.dart';
import 'Pages/products.dart';
import 'Pages/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        accentColor: Colors.deepPurple,
      ),
      home: AuthPage(),
    );
  }
}
