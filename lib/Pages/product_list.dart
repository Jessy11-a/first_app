import 'package:flutter/material.dart';
import './product_edit.dart';
import '../models/product.dart';
import '../scoped-models/products.dart';

class ProductListPage extends StatelessWidget {
  final Function updateProduct;
  final Function deleteProduct;
  final List<Product> products;

  ProductListPage(this.products, this.updateProduct, this.deleteProduct);

  Widget _buildEditButton(BuildContext context, int index) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ProductEditPage();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: Key(products[index].title! ),
          onDismissed: (DismissDirection direction) {
            if (direction == DismissDirection.endToStart) {
              deleteProduct(index);
            } else {
              print('other swiping');
            }
          },
          background: Container(color: Colors.red),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                    backgroundImage: AssetImage(products[index].image!)),
                title: Text(products[index].title!),
                subtitle: Text('\$${products[index].price.toString()}'),
                trailing: _buildEditButton(context, index),
              ),
              Divider()
            ],
          ),
        );
      },
      itemCount: products.length,
    );
  }
}
