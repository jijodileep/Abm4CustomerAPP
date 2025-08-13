import 'package:abm4_customerapp/features/Dashboard/Dealer/Cards/Place_Order/models/cart_model.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final Cart _cart = Cart();
  Cart get cart => _cart;
  List<CartItem> get items => _cart.items;
  int get totalItems => _cart.totalItems;

  double get totalAmount => _cart.totalAmount;

  bool get isEmpty => _cart.isEmpty();
}
