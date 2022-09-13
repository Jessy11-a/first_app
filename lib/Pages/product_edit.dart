import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../widgets/helpers/ensure_visible.dart';
import '../models/product.dart';
import '../scoped-models/main.dart';

class ProductEditPage extends StatefulWidget {
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

  _buildTitleTextField(Product product) {
    return EnsureVisibleWhenFocused(
        focusNode: FocusNode(),
        child: TextFormField(
            focusNode: _titleFocusNode,
            decoration: InputDecoration(labelText: 'Product Title'),
            initialValue: product.title == '' ? null : product.title,
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 5) {
                return 'Title is required and should be 5+ characters long';
              }
              return null;
            },
            onSaved: (value) {
              _formData['title'] = value;
            }));
  }

  _buildDescriptionTextField(Product product) {
    return EnsureVisibleWhenFocused(
        focusNode: FocusNode(),
        child: TextFormField(
            focusNode: _descriptionFocusNode,
            decoration: InputDecoration(labelText: 'Product Description'),
            initialValue:
                product.description == '' ? null : product.description,
            validator: (value) {
              if (value == null || value.length < 10) {
                return 'Description is required and should be 10+ characters long';
              }
              return null;
            },
            maxLines: 4,
            onSaved: (value) {
              _formData['description'] = value;
            }));
  }

  _buildPriceTextField(Product product) {
    return EnsureVisibleWhenFocused(
        focusNode: FocusNode(),
        child: TextFormField(
            focusNode: _priceFocusNode,
            decoration: InputDecoration(labelText: 'Product Price'),
            keyboardType: TextInputType.number,
            initialValue:
                product.price == 0.0 ? null : product.price.toString(),
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  !RegExp(r'^(?:[1-9]\d*|0)?(?:[.,]\d+)?$').hasMatch(value)) {
                return 'Price is required and should be number';
              }
              return null;
            },
            onSaved: (value) {
              _formData['price'] = double.parse(value!);
            }));
  }

  void _submitForm(Function addProduct, Function updateProduct,
      [int? selectedProductIndex]) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (selectedProductIndex == null) {
        addProduct(
            _formData['title'],
            _formData['description'],
            _formData['image'], 
            _formData['price'],
            );
      } else {
        updateProduct(
           _formData['title'],
           _formData['description'],
           _formData['image'], 
           _formData['price'], 
            );
      }
    Navigator.pushReplacementNamed(context, '/products');
    }

  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (context, Widget? child, MainModel model) {
        return ElevatedButton(
          child: Text('Save'),
          onPressed: () => _submitForm(model.addProduct, model.updateProduct,
              model.selectedProductIndex),
        );
      },
    );
  }

  Widget _buildPageContent(BuildContext context, Product product) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 768.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    return Container(
      width: targetWidth,
      margin: EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
          children: <Widget>[
            _buildTitleTextField(product),
            _buildDescriptionTextField(product),
            _buildPriceTextField(product),
            SizedBox(
              height: 10.0,
            ),
            _buildSubmitButton()
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, Widget? child, MainModel model) {
        final Widget pageContent =
            _buildPageContent(context, model.selectedProduct);
        return model.selectedProductIndex == null
            ? pageContent
            : Scaffold(
                appBar: AppBar(
                  title: Text('Edit Product'),
                ),
                body: pageContent,
              );
      },
    );
  }
}
