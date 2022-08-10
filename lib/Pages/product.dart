import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Product etails'),
        ),
        body: Column(
          children: [
            Text('Details'),
            ElevatedButton(
              child: Text('Back'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        )
        );
  }
}
