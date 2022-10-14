// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widgets/products/products.dart';
import '../scoped-models/main.dart';

class ProductsPage extends StatefulWidget {
  final MainModel model;

  ProductsPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProductsPageState();
  }
}

class _ProductsPageState extends State<ProductsPage> {
  initState() {
    widget.model.fetchProducts();
    super.initState();
  }

  _buildSideDrawer(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        AppBar(
          automaticallyImplyLeading: false,
          title: Text('choose'),
        ),
        ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin');
            }),
      ],
    ));
  }

  _buildProductsList() {
    return ScopedModelDescendant(
        builder: (context, Widget? child, MainModel model) {
      Widget content = Center(child: Text('No products found'));
      if (model.displayedProducts.length > 0 && !model.isLoading) {
        content = Products();
      } else if (model.isLoading) {
        content = Center(child: CircularProgressIndicator());
      }
      return RefreshIndicator(
        onRefresh: model.fetchProducts,
        child: content,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text('EasyList'),
        actions: [
          ScopedModelDescendant<MainModel>(
            builder: (context, Widget? child, MainModel model) {
              return IconButton(
                  icon: Icon(model.displayFavoritesOnly
                      ? Icons.favorite
                      : Icons.favorite),
                  onPressed: () {
                    model.toggleDisplayMode();
                  });
            },
          )
        ],
      ),
      body: _buildProductsList(),
    );
  }
}
