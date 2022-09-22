import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../pages/cart_page.dart';
import '../widgets/app_drawer.dart';
import '../providers/products_provider.dart';
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
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // THIS WON'T WORK !!
    // Provider.of<ProductsProvider>(context).fetchAndGetProducts();

    // ONE WAY IS THIS
    // Future.delayed(Duration.zero).then(
    //     (_) => Provider.of<ProductsProvider>(context).fetchAndGetProducts());
    super.initState();
  }

  // THIS IS ANOTHER AND MORE CORRECT WAY!!
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context).fetchAndGetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductsOverviewGridView(_showFavouritesOnly),
    );
  }
}
