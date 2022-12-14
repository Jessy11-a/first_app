import 'package:first_app/widgets/ui_elements/alert.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../models/auth.dart';

class ConnectedProductsModel extends Model {
  List<Product> _products = [];
  String? _selProductId;
  User? _authenticatedUser;
  bool _isLoading = false;

  Future<Null> fetchProducts(BuildContext context) {
    _isLoading = true;
    notifyListeners();
    return http
        .get(Uri.parse(
            'https://flutter-products11-default-rtdb.firebaseio.com/products.json?auth=${_authenticatedUser!.token}'))
        .then<Null>((http.Response response) {
      final List<Product> fetchedProductList = [];
      final Map<String, dynamic>? productListData = json.decode(response.body);

      // HAPA PATAKUONESHA ALERT KAMA KUKIWA NA ERROR KWEHYE KUFETCH PRODUCT
      if (response.statusCode != 200 && response.statusCode != 201) {
        print('Fetch Product');
        print(response.body);
        _isLoading = false;
        showAlertDia(
            'Error in fetching products', productListData!['error'], context);
        notifyListeners();
        return;
      }

      if (productListData == null) {
        _products = [];
        _isLoading = false;
        notifyListeners();
        return;
      }

      productListData.forEach((String productId, dynamic productData) {
        final Product product = Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            image: productData['image'],
            price: productData['price'],
            userEmail: productData['userEmail'],
            userId: productData['userId']);
        fetchedProductList.add(product);
      });
      _products = fetchedProductList;
      _isLoading = false;
      notifyListeners();
      _selProductId = null;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }
}

class ProductModel extends ConnectedProductsModel {
  bool _showFavorites = false;

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return _products.where((Product product) => product.isFavorite).toList();
    }
    return List.from(_products);
  }

  int get selectedProductIndex {
    return _products.indexWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  String? get selectedProductId {
    return _selProductId;
  }

  Product get selectedProduct {
    if (_selProductId == null) {
      return Product(
          id: '',
          title: '',
          description: '',
          price: 0.0,
          image: '',
          userEmail: '',
          userId: '');

      // return null;
    }
    return _products.firstWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  Future<bool> addProduct(
      String title, String description, String image, double price) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image': image,
      'price': price,
      'userEmail': _authenticatedUser?.email,
      'userId': _authenticatedUser?.id,
    };

    try {
      final http.Response response = await http.post(
          Uri.parse(
              'https://flutter-products11-default-rtdb.firebaseio.com/products.json?auth=${_authenticatedUser!.token}'),
          body: json.encode(productData));
      final Map<String, dynamic>? responseData = json.decode(response.body);

      if (response.statusCode != 200 && response.statusCode != 201) {
        print('Add Product Failed');
        print("ERROR: " + responseData!['error']);
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final Product newProduct = Product(
          id: responseData!['name'],
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: _authenticatedUser!.email,
          userId: _authenticatedUser!.id);
      _products.add(newProduct);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
    // .catchError((error) {
    //   _isLoading = false;
    //   notifyListeners();
    //   return false;
    // });
  }

  Future<bool> updateProduct(
      String title, String description, String image, double price) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'image': image,
      'price': price,
      'userEmail': selectedProduct.userEmail,
      'userId': selectedProduct.userId,
    };

    return http
        .put(
            Uri.parse(
                'https://flutter-products11-default-rtdb.firebaseio.com/products/${selectedProduct.id}.json?auth=${_authenticatedUser!.token}'),
            body: json.encode(updateData))
        .then((http.Response response) {
      _isLoading = false;
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId);

      // _products[_selProductIndex!] = updatedProduct;
      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> deleteProduct() {
    _isLoading = true;
    final deletedProductId = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    _selProductId = null;
    notifyListeners();
    return http
        .delete(Uri.parse(
            'https://flutter-products11-default-rtdb.firebaseio.com/products/${deletedProductId}.json?auth=${_authenticatedUser!.token}'))
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  void toggleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updatedProduct = Product(
      id: selectedProduct.id,
      title: selectedProduct.title,
      description: selectedProduct.description,
      price: selectedProduct.price,
      image: selectedProduct.image,
      userEmail: selectedProduct.userEmail,
      userId: selectedProduct.userId,
      isFavorite: newFavoriteStatus,
    );
    _products[selectedProductIndex] = updatedProduct;
    // _selProductIndex = null;
    notifyListeners();
  }

  void selectProduct(String productId) {
    _selProductId = productId;
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

class UserModel extends ConnectedProductsModel {
  User? get user {
    return _authenticatedUser;
  }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    http.Response response;
    if (mode == AuthMode.Login) {
      response = await http.post(
          Uri.parse(
            'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBcsW-DresFNvaRzANrd0vYr3PstoMu800',
          ),
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'});
    } else {
      response = await http.post(
          Uri.parse(
              'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBcsW-DresFNvaRzANrd0vYr3PstoMu800'),
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'});
      print(response.body);
    }

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong';
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeeded';
      _authenticatedUser = User(
          id: responseData['localId'],
          email: email,
          token: responseData['idToken']);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['idToken']);
      prefs.setString('userEmail', email);
      prefs.setString('userId', responseData['localId']);
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists';
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This email is not found';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'The password is invalid';
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    if (token != null) {
      final String? userEmail = prefs.getString('userEmail');
      final String? userId = prefs.getString('userId');
      _authenticatedUser = User(
        id: userId!,
        email: userEmail!,
        token: token,
      );
      notifyListeners();
    }
  }
}

class UtilityModel extends ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}
