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
  final MainModel _model = MainModel();

  @override
  void initState() {
    _model.autoAuthenticate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var onGenerateRoute;

    return ScopedModel<MainModel>(
        model: _model,
        child: MaterialApp(
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blueGrey,
              accentColor: Colors.deepPurple,
            ),
            home: AuthPage(),
            routes: {
              '/':(context) => ScopedModelDescendant (
                builder: ((BuildContext context,Widget? child,MainModel model) {
                  return model.user == null ? AuthPage() : ProductsPage(model);
                } )),
              '/products': (BuildContext context) => ProductsPage(_model),
              '/admin': (BuildContext context) => AdminProducts(_model),
            },
            onGenerateRoute: (RouteSettings settings) {
              final List<String> pathElements = settings.name!.split('/');
              if (pathElements[0] != '') {
                return null;
              }
              if (pathElements[1] == 'product') {
                final String productId = pathElements[2];
                final Product product =
                    _model.allProducts.firstWhere((Product product) {
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
                  builder: (BuildContext context) => ProductsPage(_model));
            }));
  }
}
