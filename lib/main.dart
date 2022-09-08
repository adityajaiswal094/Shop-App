import 'package:cart_management/pages/edit_product_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './pages/product_detail_page.dart';
import './pages/home_page.dart';
import './providers/products_provider.dart';
import './providers/cart.dart';
import './pages/cart_page.dart';
import './providers/orders.dart';
import './pages/orders_page.dart';
import './pages/user_products_page.dart';

void main() {
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
          create: (ctx) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shopkart',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.purple,
          ).copyWith(secondary: Colors.deepOrange),
          fontFamily: 'Lato',
        ),
        home: const HomePage(),
        routes: {
          ProductDetailPage.routeName: (context) => const ProductDetailPage(),
          CartPage.routeName: (context) => const CartPage(),
          OrdersPage.routeName: (context) => const OrdersPage(),
          UserProductsPage.routeName: (context) => const UserProductsPage(),
          EditProductPage.routeName: (context) => const EditProductPage(),
        },
      ),
    );
  }
}
