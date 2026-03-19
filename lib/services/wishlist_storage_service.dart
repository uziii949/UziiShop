import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uzii_shop/models/product_model.dart';

class WishlistStorageService {
  static const String _wishlistKey = 'uzii_wishlist';

  Future<void> saveWishlist(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonList = products.map((p) => json.encode({
      'id': p.id,
      'title': p.title,
      'price': p.price,
      'description': p.description,
      'category': p.category,
      'image': p.image,
      'rating': {'rate': p.rating.rate, 'count': p.rating.count},
    })).toList();
    await prefs.setStringList(_wishlistKey, jsonList);
  }

  Future<List<Product>> loadWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? jsonList = prefs.getStringList(_wishlistKey);
      if (jsonList == null || jsonList.isEmpty) return [];
      return jsonList
          .map((e) => Product.fromJson(json.decode(e)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> clearWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_wishlistKey);
  }
}