import 'package:flutter/material.dart';
import 'Pages/products.dart';
import 'Pages/product.dart';
import 'Pages/auth.dart';
import './Pages/products.dart';
import './Pages/admin_products.dart';

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
        //home: AuthPage(),
        routes: {
              '/': (BuildContext context) => ProductsPage(),
              '/admin': (BuildContext context) => AdminProducts(),
        });
  }
}
