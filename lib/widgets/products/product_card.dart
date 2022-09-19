import 'package:flutter/material.dart';
import './price_tag.dart';
import '../ui_elements/title_default.dart';
import '../../models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped-models/main.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int productIndex;

  ProductCard(this.product, this.productIndex);

  _buildTitlePriceDrawerContainer() {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TitleDefault(product.title),
          SizedBox(
            width: 10.0,
          ),
          PriceTag(product.price.toString()),
        ],
      ),
    );
  }

  _buildButtonBar(BuildContext context) {
    return ButtonBar(alignment: MainAxisAlignment.center, children: <Widget>[
      IconButton(
        icon: Icon(Icons.info),
        color: Colors.green,
        onPressed: () => Navigator.pushNamed<bool>(
            context, '/product/' + productIndex.toString()),
      ),
      ScopedModelDescendant<MainModel>(
        builder:(context, Widget? child, MainModel model){
        return IconButton(
        icon: Icon(model.allProducts[productIndex].isFavorite? Icons.favorite:
          Icons.favorite_border),
        color: Colors.green,
        onPressed: (){
          model.selectProduct(productIndex);
          model.toggleProductFavoriteStatus();
        },
      );
        }
      ),
      
      IconButton(
        icon: Icon(Icons.shopping_cart_outlined),
        color: Colors.green,
        onPressed: () => Navigator.pushNamed<bool>(
            context, '/product/' + productIndex.toString()),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          _buildTitlePriceDrawerContainer(),
          Image.asset(product.image),
          Text(product.userEmail),
          _buildButtonBar(context),
        ],
      ),
    );
  }
}
