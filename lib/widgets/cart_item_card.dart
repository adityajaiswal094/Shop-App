import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widgets/product_title_subtitle.dart';

class CartItemCard extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;
  final String imageUrl;

  const CartItemCard({
    Key? key,
    required this.id,
    required this.productId,
    required this.title,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.all(10.0),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeProduct(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text(
                'Are you sure?',
                style: TextStyle(fontFamily: 'Raleway'),
              ),
              content: const Text(
                'Do you want to remove the item from the cart?',
                style: TextStyle(fontFamily: 'Raleway'),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4.0),
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ITEM IMAGE
              Container(
                height: 90.0,
                width: 90.0,
                margin:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // SPACING
              const SizedBox(
                width: 10.0,
              ),

              // ITEM NAME, PRICE
              ProductTitleSubtitle(title, price.toString()),

              // SPACING
              const Spacer(),

              // ADD, REMOVE BUTTON
              Container(
                height: 27.0,
                width: 75.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9.0),
                  color: Colors.yellow[900],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Provider.of<Cart>(context, listen: false)
                          .removeSingleItem(productId),
                      child: const Icon(
                        Icons.remove_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '$quantity',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Provider.of<Cart>(context, listen: false)
                          .addItem(productId, title, price, imageUrl),
                      child: const Icon(
                        Icons.add_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
