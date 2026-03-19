import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uzii_shop/providers/orders_provider.dart';
import 'package:uzii_shop/theme/app_theme.dart';
import 'package:uzii_shop/screens/orders/widgets/order_card.dart';
import 'package:uzii_shop/screens/orders/widgets/empty_orders_view.dart';
import 'package:uzii_shop/screens/orders/order_details_screen.dart';

class OrdersHistoryScreen extends StatefulWidget {
  const OrdersHistoryScreen({super.key});

  @override
  State<OrdersHistoryScreen> createState() => _OrdersHistoryScreenState();
}

class _OrdersHistoryScreenState extends State<OrdersHistoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrdersProvider>().loadOrders().then((_) {
        _animController.forward();
      });
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = context.watch<OrdersProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Filter feature coming soon!'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ordersProvider.isLoading
          ? const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      )
          : !ordersProvider.hasOrders
          ? const EmptyOrdersView()
          : FadeTransition(
        opacity: _fadeAnim,
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () =>
              context.read<OrdersProvider>().refreshOrders(),
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: ordersProvider.orders.length,
            itemBuilder: (context, index) {
              final order = ordersProvider.orders[index];
              return OrderCard(
                order: order,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          OrderDetailsScreen(order: order),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}