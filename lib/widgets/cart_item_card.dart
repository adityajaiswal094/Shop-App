import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widgets/add_remove_button.dart';
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
              AddRemoveButton(quantity),
            ],
          ),
        ),
      ),
    );
  }
}


// ListTile(
//           leading: Container(
//             height: 90.0,
//             width: 90.0,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.circular(12.0),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Image.network(
//                 imageUrl,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           title: Text(title),
//           subtitle: Text('\$$price'),
//           trailing: null,
//         )