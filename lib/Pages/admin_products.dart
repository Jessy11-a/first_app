import 'package:flutter/material.dart';
import 'product_edit.dart';
import './product_list.dart';
import '../models/product.dart';


class AdminProducts extends StatelessWidget {
  final Function addProduct;
  final Function updateProduct;
  final Function deleteProduct;
  final List<Product> products;

  AdminProducts(
      this.addProduct, this.updateProduct, this.deleteProduct, this.products);

  _buildSideDrawer(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        AppBar(
          automaticallyImplyLeading: false,
          title: Text('Choose'),
        ),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text('All products'),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/products');
          },
        ),
      ],
    ));
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: _buildSideDrawer(context),
        appBar: AppBar(
            title: Text('Manage products'),
            bottom: TabBar(
              tabs: <Widget>[
              Tab(
                icon: Icon(Icons.create),
                text: 'Create Product',
              ),
              Tab(icon: Icon(Icons.list), text: 'My products')
            ])),
        body: TabBarView(
          children: [
            ProductEditPage(
              addProduct: addProduct,
            ),
            ProductListPage(products, updateProduct, deleteProduct),
          ],
        ),
      ),
    );
  }
}
