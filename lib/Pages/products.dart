import 'package:flutter/material.dart';

import '../product_manager.dart';
import './admin_products.dart';

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('choose'),
          ),
          ListTile(
            title: Text('Manage products'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => AdminProducts()));
            },
          ),
        ],
      )),
      appBar: AppBar(
        title: Text('EasyList'),
      ),
      body:
          ProductManager({'title': 'Food Tester', 'image': 'assets/food.jpg'}),
    );
  }
}
