import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uzii_shop/providers/profile_provider.dart';
import 'package:uzii_shop/providers/orders_provider.dart';
import 'package:uzii_shop/theme/app_theme.dart';
import 'package:uzii_shop/screens/profile/widgets/profile_header_card.dart';
import 'package:uzii_shop/screens/profile/widgets/account_option_tile.dart';
import 'package:uzii_shop/screens/profile/edit_profile_screen.dart';
import 'package:uzii_shop/screens/profile/wishlist_placeholder_screen.dart';
import 'package:uzii_shop/screens/profile/addresses_placeholder_screen.dart';
import 'package:uzii_shop/screens/profile/help_support_screen.dart';
import 'package:uzii_shop/screens/profile/about_screen.dart';
import 'package:uzii_shop/screens/orders/orders_history_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
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
      context.read<ProfileProvider>().loadProfile();
      context.read<OrdersProvider>().loadOrders();
      _animController.forward();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Logout',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(fontFamily: 'Roboto'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Logout',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await context.read<ProfileProvider>().logout();
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final ordersProvider = context.watch<OrdersProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Profile'),
        automaticallyImplyLeading: false,
      ),
      body: profileProvider.isLoading
          ? const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      )
          : FadeTransition(
        opacity: _fadeAnim,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              if (profileProvider.profile != null)
                ProfileHeaderCard(
                  profile: profileProvider.profile!,
                  onEditTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EditProfileScreen(),
                    ),
                  ).then((_) =>
                      profileProvider.loadProfile()),
                ),
              const SizedBox(height: 24),

              // Shopping Section
              _SectionHeader(title: 'Shopping'),
              const SizedBox(height: 8),
              _OptionsCard(
                children: [
                  AccountOptionTile(
                    icon: Icons.receipt_long_outlined,
                    title: 'My Orders',
                    subtitle: ordersProvider.hasOrders
                        ? '${ordersProvider.orders.length} orders placed'
                        : 'No orders yet',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OrdersHistoryScreen(),
                      ),
                    ),
                  ),
                  AccountOptionTile(
                    icon: Icons.favorite_outline,
                    title: 'Wishlist',
                    subtitle: 'Your saved items',
                    iconColor: AppColors.secondary,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const WishlistPlaceholderScreen(),
                      ),
                    ),
                  ),
                  AccountOptionTile(
                    icon: Icons.location_on_outlined,
                    title: 'Saved Addresses',
                    subtitle: 'Manage your addresses',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const AddressesPlaceholderScreen(),
                      ),
                    ),
                    showDivider: false,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Account Section
              _SectionHeader(title: 'Account'),
              const SizedBox(height: 8),
              _OptionsCard(
                children: [
                  AccountOptionTile(
                    icon: Icons.credit_card_outlined,
                    title: 'Payment Methods',
                    subtitle: 'Manage payment options',
                    iconColor: const Color(0xFF4285F4),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                              'Payment methods coming soon!'),
                          backgroundColor: AppColors.primary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                  ),
                  AccountOptionTile(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'Manage notifications',
                    iconColor: const Color(0xFFFF9800),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                              'Notifications settings coming soon!'),
                          backgroundColor: AppColors.primary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    showDivider: false,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Support Section
              _SectionHeader(title: 'Support'),
              const SizedBox(height: 8),
              _OptionsCard(
                children: [
                  AccountOptionTile(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    subtitle: 'FAQs and contact us',
                    iconColor: AppColors.success,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HelpSupportScreen(),
                      ),
                    ),
                  ),
                  AccountOptionTile(
                    icon: Icons.info_outline,
                    title: 'About UziiShop',
                    subtitle: 'Version 1.0.0',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AboutScreen(),
                      ),
                    ),
                    showDivider: false,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Logout
              _OptionsCard(
                children: [
                  AccountOptionTile(
                    icon: Icons.logout,
                    title: 'Logout',
                    iconColor: AppColors.error,
                    titleColor: AppColors.error,
                    onTap: _logout,
                    showDivider: false,
                    trailing: const SizedBox.shrink(),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Version text
              Center(
                child: Text(
                  'UziiShop v1.0.0',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 11,
                    color: AppColors.textSecondary
                        .withValues(alpha: 0.6),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _OptionsCard extends StatelessWidget {
  final List<Widget> children;
  const _OptionsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}