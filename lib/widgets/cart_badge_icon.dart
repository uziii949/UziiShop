import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uzii_shop/providers/cart_provider.dart';
import 'package:uzii_shop/theme/app_theme.dart';

class CartBadgeIcon extends StatelessWidget {
  const CartBadgeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/cart'),
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.textPrimary,
              size: 26,
            ),
            if (cart.totalQuantity > 0)
              Positioned(
                top: 0,
                right: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      cart.totalQuantity > 9
                          ? '9+'
                          : cart.totalQuantity.toString(),
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}