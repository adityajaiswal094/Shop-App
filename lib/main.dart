import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './providers/cart.dart';
import './pages/home_page.dart';
import './pages/cart_page.dart';
import './pages/auth_page.dart';
import './providers/orders.dart';
import './pages/splash_page.dart';
import './pages/orders_page.dart';
import './pages/edit_product_page.dart';
import './pages/user_products_page.dart';
import './pages/product_detail_page.dart';
import './providers/products_provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  //
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          update: (ctx, auth, previousProduct) => ProductsProvider(
              auth.token,
              auth.userId,
              previousProduct == null ? [] : previousProduct.items),
          create: (ctx) => ProductsProvider('', '', []),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousOrder) => Orders(auth.token, auth.userId,
              previousOrder == null ? [] : previousOrder.orders),
          create: (ctx) => Orders('', '', []),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shopkart',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.purple,
            ).copyWith(secondary: Colors.deepOrange),
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? const HomePage()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthPage(),
                ),
          routes: {
            HomePage.routeName: (context) => const HomePage(),
            CartPage.routeName: (context) => const CartPage(),
            OrdersPage.routeName: (context) => const OrdersPage(),
            EditProductPage.routeName: (context) => const EditProductPage(),
            UserProductsPage.routeName: (context) => const UserProductsPage(),
            ProductDetailPage.routeName: (context) => const ProductDetailPage(),
            // AuthPage.routeName: (context) => const AuthPage(),
          },
        ),
      ),
    );
  }
}
