import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uzii_shop/providers/checkout_provider.dart';
import 'package:uzii_shop/theme/app_theme.dart';

class PaymentMethodSelector extends StatelessWidget {
  const PaymentMethodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final checkout = context.watch<CheckoutProvider>();

    return Column(
      children: [
        _PaymentOption(
          title: 'Cash on Delivery',
          subtitle: 'Pay when you receive',
          icon: Icons.money_outlined,
          iconColor: AppColors.success,
          isSelected: checkout.paymentMethod == PaymentMethod.cod,
          onTap: () => context
              .read<CheckoutProvider>()
              .setPaymentMethod(PaymentMethod.cod),
        ),
        const SizedBox(height: 10),
        _PaymentOption(
          title: 'Credit / Debit Card',
          subtitle: 'Visa, Mastercard, etc.',
          icon: Icons.credit_card_outlined,
          iconColor: const Color(0xFF4285F4),
          isSelected: checkout.paymentMethod == PaymentMethod.card,
          onTap: () => context
              .read<CheckoutProvider>()
              .setPaymentMethod(PaymentMethod.card),
          note: 'Secure card payment — simulated for demo',
        ),
        const SizedBox(height: 10),
        _PaymentOption(
          title: 'EasyPaisa / JazzCash',
          subtitle: 'Mobile wallet payment',
          icon: Icons.account_balance_wallet_outlined,
          iconColor: AppColors.secondary,
          isSelected: checkout.paymentMethod == PaymentMethod.wallet,
          onTap: () => context
              .read<CheckoutProvider>()
              .setPaymentMethod(PaymentMethod.wallet),
          note: 'Wallet payment — simulated for demo',
        ),
      ],
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final bool isSelected;
  final VoidCallback onTap;
  final String? note;

  const _PaymentOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.isSelected,
    required this.onTap,
    this.note,
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
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
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
                    color:
                    isSelected ? AppColors.primary : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check,
                      size: 12, color: Colors.white)
                      : null,
                ),
              ],
            ),
            if (isSelected && note != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline,
                        size: 14, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        note!,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 11,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}