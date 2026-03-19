import 'package:flutter/material.dart';
import 'package:uzii_shop/models/product_model.dart';
import 'package:uzii_shop/theme/app_theme.dart';

class RatingRow extends StatelessWidget {
  final Rating rating;

  const RatingRow({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Stars
        Row(
          children: List.generate(5, (index) {
            final filled = index < rating.rate.floor();
            final halfFilled =
                !filled && index < rating.rate && rating.rate % 1 >= 0.5;
            return Icon(
              halfFilled
                  ? Icons.star_half_rounded
                  : filled
                  ? Icons.star_rounded
                  : Icons.star_outline_rounded,
              color: const Color(0xFFFFB800),
              size: 18,
            );
          }),
        ),
        const SizedBox(width: 8),
        Text(
          rating.rate.toString(),
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '(${rating.count} reviews)',
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}