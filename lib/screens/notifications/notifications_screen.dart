import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uzii_shop/providers/notification_provider.dart';
import 'package:uzii_shop/theme/app_theme.dart';
import 'package:uzii_shop/screens/notifications/widgets/notification_tile.dart';
import 'package:uzii_shop/screens/notifications/widgets/notifications_empty_view.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
    context.read<NotificationProvider>().loadNotifications();
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (!provider.isEmpty)
            TextButton(
              onPressed: () => provider.markAllAsRead(),
              child: const Text(
                'Mark All Read',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (!provider.isEmpty)
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: AppColors.error,
              ),
              onPressed: () => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: const Text(
                    'Clear All',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  content: const Text(
                    'Remove all notifications?',
                    style: TextStyle(fontFamily: 'Roboto'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        provider.clearAll();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Clear',
                        style: TextStyle(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      body: provider.isEmpty
          ? const NotificationsEmptyView()
          : FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          children: [
            // Unread count
            if (provider.hasUnread)
              Padding(
                padding:
                const EdgeInsets.fromLTRB(20, 12, 20, 4),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${provider.unreadCount} unread',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Notifications list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: provider.notifications.length,
                itemBuilder: (context, index) {
                  final notification =
                  provider.notifications[index];
                  return NotificationTile(
                    notification: notification,
                    onTap: () {
                      provider.markAsRead(notification.id);
                      if (notification.targetRoute != null) {
                        Navigator.pushNamed(
                          context,
                          notification.targetRoute!,
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}