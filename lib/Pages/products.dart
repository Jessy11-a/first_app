import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widgets/products/products.dart';
import '../scoped-models/products.dart';


class ProductsPage extends StatelessWidget {

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text('EasyList'),
        actions: [
          ScopedModelDescendant<ProductModel>(builder: (context, Widget? child, ProductModel model){
            return IconButton(
            icon: Icon(model.displayFavoritesOnly?
              Icons.favorite: 
              Icons.favorite), 
            onPressed: () {
              model.toggleDisplayMode();
            }
            );
          },)
          ],
      ),
      body: Products(),
    );
  }
}
