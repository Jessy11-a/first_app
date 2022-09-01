import 'package:flutter/material.dart';
import '../widgets/helpers/ensure_visible.dart';
import '../models/product.dart';

class ProductEditPage extends StatefulWidget {
  final Function? addProduct;
  final Function? updateProduct;
  final Product? product;
  final int? productIndex;

  ProductEditPage(
      {this.addProduct, this.updateProduct, this.product, this.productIndex});

  @override
  State<StatefulWidget> createState() {
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'image': 'assets/food.jpg',
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  _buildTitleTextField() {
    return EnsureVisibleWhenFocused(
        focusNode: FocusNode(),
        child: TextFormField(
            focusNode: _titleFocusNode,
            decoration: InputDecoration(labelText: 'Product Title'),
            initialValue:
                widget.product == null ? '' : widget.product!.title,
            validator: (String? value) {
              if (value!.isEmpty || value.length < 5) {
                return 'Title is required and should be 5+ characters long';
              }
            },
            onSaved: (value) {
              _formData['title'] = value;
            }));
  } 

  _buildDescriptionTextField() {
    return EnsureVisibleWhenFocused(
        focusNode: FocusNode(),
        child: TextFormField(
            focusNode: _descriptionFocusNode,
            decoration: InputDecoration(labelText: 'Product Description'),
            initialValue:
                widget.product == null ? '' : widget.product!.description,
            validator: (value) {
              if (value == null || value.length < 10) {
                return 'Description is required and should be 10+ characters long';
              }
            },
            maxLines: 4,
            onSaved: (value) {
              _formData['description'] = value;
            }));
  }

  _buildPriceTextField() {
    return EnsureVisibleWhenFocused(
        focusNode: FocusNode(),
        child: TextFormField(
            focusNode: _priceFocusNode,
            decoration: InputDecoration(labelText: 'Product Price'),
            keyboardType: TextInputType.number,
            initialValue: widget.product == null
                ? ''
                : widget.product!.price.toString(),
            validator: (String? value) {
              if (value!.isEmpty ||
                  !RegExp(r'^(?:[1-9]\d*|0)?(?:[.,]\d+)?$').hasMatch(value)) {
                return 'Price is required and should be number';
              }
            },
            onSaved: (value) {
              _formData['price'] = double.parse(value!);
            }));
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (widget.product == null) {
        widget.addProduct!(
          Product(
            title: _formData['title'],
            description: _formData['description'],
            price: _formData['price'],
            image: _formData['image']
            )
        );
      } else {
        widget.updateProduct!(widget.productIndex,
         Product(
            title: _formData['title'],
            description: _formData['description'],
            price: _formData['price'],
            image: _formData['image']
            ));
      }
      Navigator.pushReplacementNamed(context, '/products');
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 768.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    final Widget pageContent = Container(
      width: targetWidth,
      margin: EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
          children: <Widget>[
            _buildTitleTextField(),
            _buildDescriptionTextField(),
            _buildPriceTextField(),
            SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              child: Text('Save'),
              onPressed: _submitForm,
            ),
          ],
        ),
      ),
    );
    return widget.product == null
        ? pageContent
        : Scaffold(
            appBar: AppBar(
              title: Text('Edit Product'),
            ),
            body: pageContent,
          );
  }
}
