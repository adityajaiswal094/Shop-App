import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime date;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.date,
  });
}

class Orders with ChangeNotifier {
  // ignore: prefer_final_fields
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://shop-app-f6ad2-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];

    try {
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;

      //
      extractedData.forEach(
        (orderID, orderData) {
          loadedOrders.add(
            OrderItem(
              id: orderID,
              amount: orderData['amount'],
              date: DateTime.parse(orderData['date']),
              products: (orderData['products'] as List<dynamic>)
                  .map(
                    (item) => CartItem(
                      id: item['id'],
                      title: item['title'],
                      price: item['price'],
                      quantity: item['quantity'],
                      imageUrl: item['imageUrl'],
                    ),
                  )
                  .toList(),
            ),
          );
        },
      );
    } catch (error) {
      return;
    }
    //
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double totalAmount) async {
    final url = Uri.parse(
        'https://shop-app-f6ad2-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: jsonEncode({
        'amount': totalAmount,
        'date': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                  'imageUrl': cp.imageUrl,
                })
            .toList(),
      }),
    );

    //
    _orders.insert(
      0,
      OrderItem(
        id: jsonDecode(response.body)['name'],
        amount: totalAmount,
        products: cartProducts,
        date: timestamp,
      ),
    );

    notifyListeners();
  }
}
