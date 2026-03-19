enum NotificationType { order, offer, wishlist, system }

class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime createdAt;
  bool isRead;
  final String? targetRoute;
  final String? targetId;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.targetRoute,
    this.targetId,
  });

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}


List<AppNotification> getMockNotifications() => [
  AppNotification(
    id: '1',
    title: 'Order Placed! 🎉',
    message: 'Your order has been placed successfully.',
    type: NotificationType.order,
    createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    targetRoute: '/orders',
  ),
  AppNotification(
    id: '2',
    title: 'Flash Sale! ⚡',
    message: '50% off on electronics. Limited time only!',
    type: NotificationType.offer,
    createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    targetRoute: '/home',
  ),
  AppNotification(
    id: '3',
    title: 'Wishlist Item Available',
    message: 'A product in your wishlist is back in stock!',
    type: NotificationType.wishlist,
    createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    targetRoute: '/wishlist',
  ),
  AppNotification(
    id: '4',
    title: 'New Collection 👗',
    message: "Women's summer collection just dropped!",
    type: NotificationType.offer,
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    targetRoute: '/home',
  ),
  AppNotification(
    id: '5',
    title: 'Order Shipped! 🚚',
    message: 'Your order is on the way. Track it now.',
    type: NotificationType.order,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    targetRoute: '/orders',
  ),
  AppNotification(
    id: '6',
    title: 'Special Discount 🎁',
    message: 'Use code UZI10 for 10% off your next order!',
    type: NotificationType.system,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
];