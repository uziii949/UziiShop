import 'package:flutter/material.dart';
import 'package:uzii_shop/models/cart_item_model.dart';
import 'package:uzii_shop/models/product_model.dart';
import 'package:uzii_shop/services/cart_storage_service.dart';

class CartProvider extends ChangeNotifier {
  final CartStorageService _storage = CartStorageService();
  final Map<int, CartItem> _items = {};
  static const double deliveryFee = 5.99;

  Map<int, CartItem> get items => _items;
  int get itemCount => _items.length;
  double get deliveryCharge => _items.isEmpty ? 0.0 : deliveryFee;

  int get totalQuantity =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get totalPrice => subtotal + deliveryCharge;

  bool isInCart(int productId) => _items.containsKey(productId);
  int getQuantity(int productId) => _items[productId]?.quantity ?? 0;

  // Load cart from storage
  Future<void> loadCart() async {
    final savedItems = await _storage.loadCart();
    _items.addAll(savedItems);
    notifyListeners();
  }

  // Add to cart
  void addToCart(Product product, {int quantity = 1}) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += quantity;
    } else {
      _items[product.id] = CartItem(
        productId: product.id,
        title: product.title,
        image: product.image,
        price: product.price,
        category: product.category,
        quantity: quantity,
      );
    }
    _saveCart();
    notifyListeners();
  }

  // Remove from cart
  void removeFromCart(int productId) {
    _items.remove(productId);
    _saveCart();
    notifyListeners();
  }

  // Increase quantity
  void increaseQuantity(int productId) {
    if (_items.containsKey(productId)) {
      _items[productId]!.quantity++;
      _saveCart();
      notifyListeners();
    }
  }

  // Decrease quantity
  void decreaseQuantity(int productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId]!.quantity > 1) {
        _items[productId]!.quantity--;
      } else {
        _items.remove(productId);
      }
      _saveCart();
      notifyListeners();
    }
  }

  // Clear cart
  void clearCart() {
    _items.clear();
    _storage.clearCart();
    notifyListeners();
  }

  // Save to storage
  Future<void> _saveCart() async {
    await _storage.saveCart(_items);
  }
}