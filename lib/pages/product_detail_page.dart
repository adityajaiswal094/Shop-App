import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';

class ProductDetailPage extends StatelessWidget {
  // final String title;
  static const routeName = '/product-detail';

  const ProductDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prodId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProducts = Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).findById(prodId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProducts.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            SizedBox(
              height: 350,
              width: double.infinity,
              child: Image.network(loadedProducts.imageUrl),
            ),

            // SPACING
            const SizedBox(
              height: 15.0,
            ),

            // DETAILS
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              // alignment: Alignment.centerLeft,
              child: RichText(
                textAlign: TextAlign.start,
                softWrap: true,
                text: TextSpan(
                  style: const TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: '${loadedProducts.title} ',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    TextSpan(
                      text: ' ${loadedProducts.description}',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // SPACING
            const SizedBox(
              height: 5.0,
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                '\$${loadedProducts.price}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
