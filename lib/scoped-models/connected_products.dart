import 'package:scoped_model/scoped_model.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/user.dart';

class ConnectedProductsModel extends Model {
  List<Product> _products = [];
  int? _selProductIndex;
  User? _authenticatedUser;
  bool _isLoading = false;

  void fetchProducts() {
    _isLoading = true;
    notifyListeners();
    http
        .get(Uri.parse(
            'https://flutter-products11-default-rtdb.firebaseio.com/products.json'))
        .then((http.Response response) {
      final List<Product> fetchedProductList = [];
      final Map<String, dynamic>? productListData = json.decode(response.body);

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
    });
  }

  Future<Null> addProduct(
      String title, String description, String image, double price) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image': image,
      'price': price,
      'userEmail': _authenticatedUser!.email,
      'userId': _authenticatedUser!.id,
    };
    return http
        .post(
            Uri.parse(
                'https://flutter-products11-default-rtdb.firebaseio.com/products.json'),
            body: json.encode(productData))
        .then((http.Response response) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      final Product newProduct = Product(
          id: responseData['name'],
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: _authenticatedUser!.email,
          userId: _authenticatedUser!.id);
      _products.add(newProduct);
      _isLoading = false;
      notifyListeners();
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

  int? get selectedProductIndex {
    return _selProductIndex;
  }

  Product get selectedProduct {
    if (_selProductIndex == null) {
      return Product(
          id: '',
          title: '',
          description: '',
          price: 0.0,
          image: '',
          userEmail: '',
          userId: '');
    }
    return _products[_selProductIndex!];
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  void updateProduct(
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

    http
        .put(Uri.parse(
            'https://flutter-products11-default-rtdb.firebaseio.com/products/${selectedProduct.id}.json'),
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
        userId: selectedProduct.userId,
      );
      _products[_selProductIndex!] = updatedProduct;
      // _selProductIndex = null;
      notifyListeners();
    });
  }

  void deleteProduct() {
    _products.removeAt(_selProductIndex!);
    //  _selProductIndex = null;
    notifyListeners();
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
    _products[_selProductIndex!] = updatedProduct;
    // _selProductIndex = null;
    notifyListeners();
  }

  void selectProduct(int index) {
    _selProductIndex = index;
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

class UserModel extends ConnectedProductsModel {
  void login(String email, String password) {
    _authenticatedUser = User(id: '123', email: email, password: password);
  }
}

class UtilityModel extends ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}
