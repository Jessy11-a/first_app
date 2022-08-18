import 'package:flutter/material.dart';

class PriceTag extends StatelessWidget {
  final String price;

  PriceTag(this.price);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
        //decoration: BoxDecoration(
          //border: Border.all(color: Colors.grey, width: 1.0),
            //borderRadius: BorderRadius.circular(5.0)),
        child: Text(
          '\$$price',
          
        ));
  }
}
