import 'package:cart_management/widgets/app_drawer.dart';
import 'package:cart_management/widgets/order_item_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';

class OrdersPage extends StatelessWidget {
  static const routeName = '/orders';
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previous Orders'),
        titleSpacing: 0.0,
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx, index) {
          return OrderItemCard(orderData.orders[index]);
        },
      ),
    );
  }
}
