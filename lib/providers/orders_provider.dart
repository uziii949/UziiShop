import 'package:flutter/material.dart';
import 'package:uzii_shop/models/order_model.dart';
import 'package:uzii_shop/services/order_storage_service.dart';

enum OrdersStatus { idle, loading, success, error }

class OrdersProvider extends ChangeNotifier {
  final OrderStorageService _storage = OrderStorageService();

  List<OrderModel> _orders = [];
  OrdersStatus _status = OrdersStatus.idle;

  List<OrderModel> get orders => _orders;
  OrdersStatus get status => _status;
  bool get isLoading => _status == OrdersStatus.loading;
  bool get hasOrders => _orders.isNotEmpty;

  // Load orders
  Future<void> loadOrders() async {
    _setStatus(OrdersStatus.loading);
    try {
      _orders = await _storage.loadOrders();
      _setStatus(OrdersStatus.success);
    } catch (e) {
      _setStatus(OrdersStatus.error);
    }
  }

  // Refresh orders
  Future<void> refreshOrders() async {
    await loadOrders();
  }

  // Get order by ID
  OrderModel? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((o) => o.orderId == orderId);
    } catch (e) {
      return null;
    }
  }

  void _setStatus(OrdersStatus status) {
    _status = status;
    notifyListeners();
  }
}