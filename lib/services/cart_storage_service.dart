import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uzii_shop/models/cart_item_model.dart';

class CartStorageService {
  static const String _cartKey = 'uzii_cart_items';

  // Save cart to SharedPreferences
  Future<void> saveCart(Map<int, CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonList =
    items.values.map((item) => json.encode(item.toJson())).toList();
    await prefs.setStringList(_cartKey, jsonList);
  }

  // Load cart from SharedPreferences
  Future<Map<int, CartItem>> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? jsonList = prefs.getStringList(_cartKey);
      if (jsonList == null || jsonList.isEmpty) return {};

      final Map<int, CartItem> items = {};
      for (final jsonStr in jsonList) {
        final item = CartItem.fromJson(json.decode(jsonStr));
        items[item.productId] = item;
      }
      return items;
    } catch (e) {
      return {};
    }
  }

  // Clear cart from SharedPreferences
  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }
}