// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import './products.dart';
import './product_create.dart';
import './product_list.dart';

// ignore: use_key_in_widget_constructors
class AdminProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          drawer: Drawer(
              child: Column(
            children: <Widget>[
              AppBar(
                automaticallyImplyLeading: false,
                title: Text('Choose'),
              ),
              ListTile(
                title: Text('All products'),
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, '/');
                },
              ),
            ],
          )),
          appBar: AppBar(
              title: Text('Manage products'),
              bottom: TabBar(tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.create),
                  text: 'Create Product',
                ),
                Tab(
                  icon: Icon(Icons.list),
                  text: 'My products')
              ])),
          body: TabBarView(children: [
            ProductCreatePage(),
            ProductListPage(),
            ],),
    ),);
  }
}
