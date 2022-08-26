import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/products/price_tag.dart';
import '../widgets/products/products.dart';
import '../widgets/ui_elements/title_default.dart';
import '../widgets/products/address_tag.dart';

class ProductPage extends StatelessWidget {
  //final String title;
  //final String imageUrl;
  //final double price;
  //final String description;

  final Map<String, dynamic> product;
  ProductPage(this.product);
  //ProductPage(this.title, this.imageUrl, this.price, this.description);

  _buildRowAddressPrice() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        AddressTag('Paris, Italy'),
        SizedBox(
          width: 5.0,
        ),
        PriceTag(product['price'].toString()),
      ]),
    ]);
  }

  _showWarningDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('This action cannot be undone'),
            actions: <Widget>[
              FlatButton(
                child: Text('DISCARD'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('CONTINUE'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          print('Back button pressed');
          Navigator.pop(context, false);
          return Future.value(false);
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(product['title']),
            ),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(product['image']),
                  Container(
                      padding: EdgeInsets.all(10.0),
                      child: TitleDefault(product['title'])),
                  
                  _buildRowAddressPrice(),

                  
                  Text(product['description']),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      child: Text('Delete'),
                      onPressed: () => _showWarningDialog(context),
                    ),
                  )
                ])));
  }
}
