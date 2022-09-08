import 'package:flutter/material.dart';

class CartItem with ChangeNotifier {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
}

class Cart with ChangeNotifier {
  // int totalQuantity = 0;

  // ignore: prefer_final_fields
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });

    return total;
  }

  int get totalQuantity {
    var total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.quantity;
    });

    return total;
  }

  void addItem(String productId, String title, double price, String imageUrl) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
          imageUrl: existingCartItem.imageUrl,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
          imageUrl: imageUrl,
        ),
      );
    }

    notifyListeners();
  }

  // TO DO
  // void addMoreQuantity() {}

  void removeProduct(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
          imageUrl: existingCartItem.imageUrl,
        ),
      );
    } else {
      _items.remove(productId);
    }

    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
