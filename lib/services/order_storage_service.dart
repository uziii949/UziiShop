import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uzii_shop/models/order_model.dart';

class OrderStorageService {
  static const String _ordersKey = 'uzii_orders';

  // Save new order
  Future<void> saveOrder(OrderModel order) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> existing = prefs.getStringList(_ordersKey) ?? [];
    existing.add(json.encode(order.toJson()));
    await prefs.setStringList(_ordersKey, existing);
  }

  // Load all orders
  Future<List<OrderModel>> loadOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? jsonList = prefs.getStringList(_ordersKey);
      if (jsonList == null || jsonList.isEmpty) return [];
      return jsonList
          .map((e) => OrderModel.fromJson(json.decode(e)))
          .toList()
          .reversed
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Clear all orders
  Future<void> clearOrders() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_ordersKey);
  }
}