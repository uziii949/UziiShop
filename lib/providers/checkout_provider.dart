import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uzii_shop/models/order_model.dart';
import 'package:uzii_shop/models/shipping_address_model.dart';
import 'package:uzii_shop/models/cart_item_model.dart';
import 'package:uzii_shop/services/order_storage_service.dart';

enum DeliveryMethod { standard, express, sameDay }
enum PaymentMethod { cod, card, wallet }
enum CheckoutStatus { idle, loading, success, error }

class CheckoutProvider extends ChangeNotifier {
  final OrderStorageService _storage = OrderStorageService();
  final _uuid = const Uuid();

  // Delivery method
  DeliveryMethod _deliveryMethod = DeliveryMethod.standard;
  DeliveryMethod get deliveryMethod => _deliveryMethod;

  // Payment method
  PaymentMethod _paymentMethod = PaymentMethod.cod;
  PaymentMethod get paymentMethod => _paymentMethod;

  // Promo code
  String _promoCode = '';
  bool _promoApplied = false;
  double _discountPercent = 0.0;
  String _promoMessage = '';

  String get promoCode => _promoCode;
  bool get promoApplied => _promoApplied;
  String get promoMessage => _promoMessage;

  // Status
  CheckoutStatus _status = CheckoutStatus.idle;
  CheckoutStatus get status => _status;
  bool get isLoading => _status == CheckoutStatus.loading;

  // Last order
  OrderModel? _lastOrder;
  OrderModel? get lastOrder => _lastOrder;

  // Delivery fees
  double get deliveryFee {
    switch (_deliveryMethod) {
      case DeliveryMethod.standard:
        return 5.99;
      case DeliveryMethod.express:
        return 12.99;
      case DeliveryMethod.sameDay:
        return 19.99;
    }
  }

  // Delivery labels
  String get deliveryLabel {
    switch (_deliveryMethod) {
      case DeliveryMethod.standard:
        return 'Standard Delivery';
      case DeliveryMethod.express:
        return 'Express Delivery';
      case DeliveryMethod.sameDay:
        return 'Same Day Delivery';
    }
  }

  // Payment label
  String get paymentLabel {
    switch (_paymentMethod) {
      case PaymentMethod.cod:
        return 'Cash on Delivery';
      case PaymentMethod.card:
        return 'Credit / Debit Card';
      case PaymentMethod.wallet:
        return 'EasyPaisa / JazzCash';
    }
  }

  // Set delivery method
  void setDeliveryMethod(DeliveryMethod method) {
    _deliveryMethod = method;
    notifyListeners();
  }

  // Set payment method
  void setPaymentMethod(PaymentMethod method) {
    _paymentMethod = method;
    notifyListeners();
  }

  // Apply promo code
  void applyPromoCode(String code) {
    if (_promoApplied) {
      _promoMessage = 'Promo code already applied!';
      notifyListeners();
      return;
    }
    if (code.trim().toUpperCase() == 'UZI10') {
      _promoCode = code.trim().toUpperCase();
      _promoApplied = true;
      _discountPercent = 0.10;
      _promoMessage = '10% discount applied! 🎉';
    } else {
      _promoMessage = 'Invalid promo code';
    }
    notifyListeners();
  }

  // Remove promo
  void removePromo() {
    _promoCode = '';
    _promoApplied = false;
    _discountPercent = 0.0;
    _promoMessage = '';
    notifyListeners();
  }

  // Calculate totals
  double getDiscount(double subtotal) => subtotal * _discountPercent;
  double getTax(double subtotal) => subtotal * 0.05;
  double getTotal(double subtotal) {
    final discount = getDiscount(subtotal);
    final tax = getTax(subtotal);
    return subtotal - discount + deliveryFee + tax;
  }

  // Place order
  Future<bool> placeOrder({
    required ShippingAddress address,
    required List<CartItem> cartItems,
    required double subtotal,
  }) async {
    _setStatus(CheckoutStatus.loading);
    try {
      await Future.delayed(const Duration(seconds: 2)); // Simulate processing

      final user = FirebaseAuth.instance.currentUser;
      final order = OrderModel(
        orderId: _uuid.v4().substring(0, 8).toUpperCase(),
        userId: user?.uid ?? 'guest',
        shippingAddress: address,
        cartItems: cartItems,
        subtotal: subtotal,
        discount: getDiscount(subtotal),
        deliveryFee: deliveryFee,
        tax: getTax(subtotal),
        total: getTotal(subtotal),
        deliveryMethod: deliveryLabel,
        paymentMethod: paymentLabel,
        promoCode: _promoCode,
        createdAt: DateTime.now(),
      );

      await _storage.saveOrder(order);
      _lastOrder = order;
      _setStatus(CheckoutStatus.success);
      _resetCheckout();
      return true;
    } catch (e) {
      _setStatus(CheckoutStatus.error);
      return false;
    }
  }

  void _resetCheckout() {
    _deliveryMethod = DeliveryMethod.standard;
    _paymentMethod = PaymentMethod.cod;
    removePromo();
  }

  void _setStatus(CheckoutStatus status) {
    _status = status;
    notifyListeners();
  }

  void resetStatus() {
    _status = CheckoutStatus.idle;
    notifyListeners();
  }
}