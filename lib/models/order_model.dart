import 'dart:convert';
import 'package:uzii_shop/models/cart_item_model.dart';
import 'package:uzii_shop/models/shipping_address_model.dart';

class OrderModel {
  final String orderId;
  final String userId;
  final ShippingAddress shippingAddress;
  final List<CartItem> cartItems;
  final double subtotal;
  final double discount;
  final double deliveryFee;
  final double tax;
  final double total;
  final String deliveryMethod;
  final String paymentMethod;
  final String promoCode;
  final String orderStatus;
  final DateTime createdAt;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.shippingAddress,
    required this.cartItems,
    required this.subtotal,
    required this.discount,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    required this.deliveryMethod,
    required this.paymentMethod,
    this.promoCode = '',
    this.orderStatus = 'Placed',
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'orderId': orderId,
    'userId': userId,
    'shippingAddress': shippingAddress.toJson(),
    'cartItems': cartItems.map((e) => e.toJson()).toList(),
    'subtotal': subtotal,
    'discount': discount,
    'deliveryFee': deliveryFee,
    'tax': tax,
    'total': total,
    'deliveryMethod': deliveryMethod,
    'paymentMethod': paymentMethod,
    'promoCode': promoCode,
    'orderStatus': orderStatus,
    'createdAt': createdAt.toIso8601String(),
  };

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    orderId: json['orderId'],
    userId: json['userId'],
    shippingAddress:
    ShippingAddress.fromJson(json['shippingAddress']),
    cartItems: (json['cartItems'] as List)
        .map((e) => CartItem.fromJson(e))
        .toList(),
    subtotal: (json['subtotal'] as num).toDouble(),
    discount: (json['discount'] as num).toDouble(),
    deliveryFee: (json['deliveryFee'] as num).toDouble(),
    tax: (json['tax'] as num).toDouble(),
    total: (json['total'] as num).toDouble(),
    deliveryMethod: json['deliveryMethod'],
    paymentMethod: json['paymentMethod'],
    promoCode: json['promoCode'] ?? '',
    orderStatus: json['orderStatus'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}