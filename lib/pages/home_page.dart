import 'package:cart_management/pages/cart_page.dart';
import 'package:cart_management/providers/cart.dart';
import 'package:cart_management/widgets/app_drawer.dart';
import 'package:cart_management/widgets/badge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_overview_gridview.dart';

enum FilterOptions {
  favourites,
  all,
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _showFavouritesOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shopkart',
        ),
        actions: [
          // PopUp
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.favourites) {
                  _showFavouritesOnly = true;
                } else {
                  _showFavouritesOnly = false;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.favourites,
                child: Text('Only Favourites'),
              ),
              const PopupMenuItem(
                value: FilterOptions.all,
                child: Text('Show All'),
              ),
            ],
          ),

          // Cart Icon
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              value: cart.totalQuantity.toString(),
              child: ch!,
            ),
            child: IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartPage.routeName),
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
        titleSpacing: 0.0,
      ),
      drawer: const AppDrawer(),
      body: ProductsOverviewGridView(_showFavouritesOnly),
    );
  }
}
