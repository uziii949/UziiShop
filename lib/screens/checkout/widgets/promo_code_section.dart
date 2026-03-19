import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uzii_shop/providers/checkout_provider.dart';
import 'package:uzii_shop/theme/app_theme.dart';

class PromoCodeSection extends StatefulWidget {
  const PromoCodeSection({super.key});

  @override
  State<PromoCodeSection> createState() => _PromoCodeSectionState();
}

class _PromoCodeSectionState extends State<PromoCodeSection> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checkout = context.watch<CheckoutProvider>();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                enabled: !checkout.promoApplied,
                textCapitalization: TextCapitalization.characters,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter promo code (e.g. UZI10)',
                  hintStyle: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                  prefixIcon: const Icon(
                    Icons.local_offer_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: checkout.promoApplied
                      ? AppColors.success.withValues(alpha: 0.05)
                      : AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: checkout.promoApplied
                          ? AppColors.success
                          : AppColors.divider,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: AppColors.primary, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
              ),
            ),
            const SizedBox(width: 10),
            checkout.promoApplied
                ? GestureDetector(
              onTap: () {
                context.read<CheckoutProvider>().removePromo();
                _controller.clear();
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.error),
                ),
                child: const Center(
                  child: Text(
                    'Remove',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ),
            )
                : GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                context
                    .read<CheckoutProvider>()
                    .applyPromoCode(_controller.text);
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Apply',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (checkout.promoMessage.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                checkout.promoApplied
                    ? Icons.check_circle_outline
                    : Icons.error_outline,
                size: 14,
                color: checkout.promoApplied
                    ? AppColors.success
                    : AppColors.error,
              ),
              const SizedBox(width: 6),
              Text(
                checkout.promoMessage,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  color: checkout.promoApplied
                      ? AppColors.success
                      : AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}