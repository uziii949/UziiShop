import 'package:flutter/material.dart';
import 'package:uzii_shop/models/product_model.dart';
import 'package:uzii_shop/services/wishlist_storage_service.dart';

class WishlistProvider extends ChangeNotifier {
  final WishlistStorageService _storage = WishlistStorageService();
  List<Product> _wishlistProducts = [];

  List<Product> get wishlistProducts => _wishlistProducts;
  int get count => _wishlistProducts.length;
  bool get isEmpty => _wishlistProducts.isEmpty;

  bool isWishlisted(int productId) =>
      _wishlistProducts.any((p) => p.id == productId);

  // Load wishlist from storage
  Future<void> loadWishlist() async {
    _wishlistProducts = await _storage.loadWishlist();
    notifyListeners();
  }

  // Toggle wishlist
  void toggleWishlist(Product product) {
    if (isWishlisted(product.id)) {
      _wishlistProducts.removeWhere((p) => p.id == product.id);
    } else {
      _wishlistProducts.add(product);
    }
    _storage.saveWishlist(_wishlistProducts);
    notifyListeners();
  }

  // Remove from wishlist
  void removeFromWishlist(int productId) {
    _wishlistProducts.removeWhere((p) => p.id == productId);
    _storage.saveWishlist(_wishlistProducts);
    notifyListeners();
  }

  // Clear all
  void clearWishlist() {
    _wishlistProducts.clear();
    _storage.clearWishlist();
    notifyListeners();
  }
}