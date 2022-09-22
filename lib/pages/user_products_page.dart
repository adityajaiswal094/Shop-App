import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import '../pages/edit_product_page.dart';

class UserProductsPage extends StatelessWidget {
  static const routeName = '/user-products';

  const UserProductsPage({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext ctx) async {
    await Provider.of<ProductsProvider>(ctx, listen: false)
        .fetchAndGetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProductPage.routeName, arguments: '');
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: ListView.builder(
          itemCount: productsData.items.length,
          itemBuilder: (ctx, index) {
            return Column(
              children: [
                UserProductItem(
                  id: productsData.items[index].id,
                  title: productsData.items[index].title,
                  imageUrl: productsData.items[index].imageUrl,
                ),
                const Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}
