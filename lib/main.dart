import 'package:flutter/material.dart';
import 'Pages/products.dart';
import 'Pages/product.dart';
import 'Pages/auth.dart';
import './Pages/products.dart';
import './Pages/admin_products.dart';
import './models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import './scoped-models/main.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    var onGenerateRoute;

    final MainModel model = MainModel();
    return ScopedModel<MainModel>(
        model: model,
        child: MaterialApp(
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blueGrey,
              accentColor: Colors.deepPurple,
            ),
            home: AuthPage(),
            routes: {
              //'/':(context) => AuthPage(),
              '/products': (BuildContext context) => ProductsPage(model),
              '/admin': (BuildContext context) => AdminProducts(model),
            },
            onGenerateRoute: (RouteSettings settings) {
              final List<String> pathElements = settings.name!.split('/');
              if (pathElements[0] != '') {
                return null;
              }
              if (pathElements[1] == 'product') {
                final String productId = pathElements[2];
                final Product product =
                    model.allProducts.firstWhere((Product product) {
                  return product.id == productId;
                });

                return MaterialPageRoute<bool>(
                  builder: (BuildContext context) => ProductPage(product),
                );
              }
              return null;
            },
            onUnknownRoute: (RouteSettings settings) {
              return MaterialPageRoute<bool>(
                  builder: (BuildContext context) => ProductsPage(model));
            }));
  }
}
