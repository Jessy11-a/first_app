import 'package:flutter/material.dart';
import 'Pages/products.dart';
import 'Pages/product.dart';
import 'Pages/auth.dart';
import './Pages/products.dart';
import './Pages/admin_products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  List<Map<String, String>> _products = [];

void _addProduct(Map<String, String> product) {
    setState(() {
      _products.add(product);
    });
  }

  void _deleteProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }


  @override
  Widget build(BuildContext context) {
    var onGenerateRoute;

    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        accentColor: Colors.deepPurple,
      ),
      //home: AuthPage(),

      routes: {
        '/': (BuildContext context) => ProductsPage(_products, _addProduct, _deleteProduct ),
        '/admin': (BuildContext context) => AdminProducts(),
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');
          if (pathElement[0] != '') {
            return null;
          }
          if (pathElement[1] == 'product') {
            final int index = int.parse(pathElement[2]);
            return MaterialPageRoute(
              builder: (BuildContext context) => ProductPage(
                  _products[index]['title']!, _products[index]['image']!),
            );
          }
          return null;
        },
      },
    );
  }
}
