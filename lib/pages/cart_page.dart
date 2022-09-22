import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/orders.dart';
import '../widgets/cart_item_card.dart';

class CartPage extends StatelessWidget {
  static const routeName = '/cart-page';
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          // LISTVIEW FOR CART ITEMS
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (ctx, index) {
                return CartItemCard(
                  id: cart.items.values.toList()[index].id,
                  productId: cart.items.keys.toList()[index],
                  title: cart.items.values.toList()[index].title,
                  price: cart.items.values.toList()[index].price,
                  quantity: cart.items.values.toList()[index].quantity,
                  imageUrl: cart.items.values.toList()[index].imageUrl,
                );
              },
            ),
          ),

          // TOTAL AND ORDER BUTTON
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        '\$${cart.totalAmount.toStringAsFixed(2)}',
                      ),
                    ],
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircularProgressIndicator(),
          )
        : ElevatedButton(
            onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });

                    //
                    await Provider.of<Orders>(context, listen: false).addOrder(
                        widget.cart.items.values.toList(),
                        widget.cart.totalAmount);
                    widget.cart.clearCart();
                    setState(() {
                      _isLoading = false;
                    });
                  },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Place Order',
              style: TextStyle(fontSize: 18.0),
            ),
          );
  }
}
