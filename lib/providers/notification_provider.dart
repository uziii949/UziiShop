import 'package:flutter/material.dart';
import 'package:uzii_shop/models/app_notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  List<AppNotification> _notifications = [];
  bool _isLoaded = false;

  List<AppNotification> get notifications => _notifications;
  int get unreadCount =>
      _notifications.where((n) => !n.isRead).length;
  bool get hasUnread => unreadCount > 0;
  bool get isEmpty => _notifications.isEmpty;

  // Load mock notifications
  void loadNotifications() {
    if (!_isLoaded) {
      _notifications = getMockNotifications();
      _isLoaded = true;
      notifyListeners();
    }
  }

  // Mark single as read
  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  // Mark all as read
  void markAllAsRead() {
    for (final n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  // Clear all
  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }

  // Add new notification
  void addNotification(AppNotification notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }
}