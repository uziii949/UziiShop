import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uzii_shop/models/product_model.dart';
import 'package:uzii_shop/providers/wishlist_provider.dart';
import 'package:uzii_shop/theme/app_theme.dart';

class FavoriteButton extends StatefulWidget {
  final Product product;
  final double size;
  final bool showBackground;

  const FavoriteButton({
    super.key,
    required this.product,
    this.size = 20,
    this.showBackground = true,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap(WishlistProvider wishlist) {
    _controller.forward().then((_) => _controller.reverse());
    final wasWishlisted = wishlist.isWishlisted(widget.product.id);
    wishlist.toggleWishlist(widget.product);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          wasWishlisted
              ? 'Removed from wishlist'
              : 'Added to wishlist ❤️',
        ),
        backgroundColor:
        wasWishlisted ? AppColors.textSecondary : AppColors.secondary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();
    final isWishlisted = wishlist.isWishlisted(widget.product.id);

    return GestureDetector(
      onTap: () => _handleTap(wishlist),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: widget.showBackground
            ? Container(
          width: widget.size + 16,
          height: widget.size + 16,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 6,
              ),
            ],
          ),
          child: Icon(
            isWishlisted ? Icons.favorite : Icons.favorite_outline,
            size: widget.size,
            color: isWishlisted
                ? AppColors.secondary
                : AppColors.textSecondary,
          ),
        )
            : Icon(
          isWishlisted ? Icons.favorite : Icons.favorite_outline,
          size: widget.size,
          color: isWishlisted
              ? AppColors.secondary
              : AppColors.textSecondary,
        ),
      ),
    );
  }
}