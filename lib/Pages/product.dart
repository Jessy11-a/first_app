import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/products/price_tag.dart';
import '../widgets/products/products.dart';
import '../widgets/ui_elements/title_default.dart';
import '../widgets/products/address_tag.dart';
import '../models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

class ProductPage extends StatelessWidget {
  final Product? product;

  ProductPage(this.product);

  
  _buildRowAddressPrice(double? price) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        AddressTag('Paris, Italy'),
        SizedBox(
          width: 5.0,
        ),
        // PriceTag(productIndex.price.toString()),

        Text(
          '\$' + price.toString(),
        )
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
    return WillPopScope(onWillPop: () {
      print('Back button pressed');
      Navigator.pop(context, false);
      return Future.value(false);
    }, child:  Scaffold(
            appBar: AppBar(
              title: Text(product!.title),
            ),
            body: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  FadeInImage(
                    placeholder: AssetImage('assets/food.jpg'),
                    image: NetworkImage(product!.image),
                  ),
                  Container(
                      padding: EdgeInsets.all(10.0),
                      child: TitleDefault(product!.title)),
                  _buildRowAddressPrice(product!.price),
                  Text(product!.description),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      child: Text('Delete'),
                      onPressed: () => _showWarningDialog(context),
                    ),
                  )
                ]))));
      }
  }

