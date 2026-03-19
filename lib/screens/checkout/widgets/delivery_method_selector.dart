import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uzii_shop/providers/checkout_provider.dart';
import 'package:uzii_shop/theme/app_theme.dart';

class DeliveryMethodSelector extends StatelessWidget {
  const DeliveryMethodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final checkout = context.watch<CheckoutProvider>();

    return Column(
      children: [
        _DeliveryOption(
          title: 'Standard Delivery',
          subtitle: '3–5 business days',
          fee: '\$5.99',
          icon: Icons.local_shipping_outlined,
          isSelected: checkout.deliveryMethod == DeliveryMethod.standard,
          onTap: () => context
              .read<CheckoutProvider>()
              .setDeliveryMethod(DeliveryMethod.standard),
        ),
        const SizedBox(height: 10),
        _DeliveryOption(
          title: 'Express Delivery',
          subtitle: '1–2 business days',
          fee: '\$12.99',
          icon: Icons.flash_on_outlined,
          isSelected: checkout.deliveryMethod == DeliveryMethod.express,
          onTap: () => context
              .read<CheckoutProvider>()
              .setDeliveryMethod(DeliveryMethod.express),
        ),
        const SizedBox(height: 10),
        _DeliveryOption(
          title: 'Same Day Delivery',
          subtitle: 'Order before 12PM',
          fee: '\$19.99',
          icon: Icons.rocket_launch_outlined,
          isSelected: checkout.deliveryMethod == DeliveryMethod.sameDay,
          onTap: () => context
              .read<CheckoutProvider>()
              .setDeliveryMethod(DeliveryMethod.sameDay),
        ),
      ],
    );
  }
}

class _DeliveryOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final String fee;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _DeliveryOption({
    required this.title,
    required this.subtitle,
    required this.fee,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.06)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : AppColors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textSecondary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              fee,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.divider,
                  width: 2,
                ),
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}