import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uzii_shop/providers/search_provider.dart';
import 'package:uzii_shop/theme/app_theme.dart';

class ActiveFilterChips extends StatelessWidget {
  const ActiveFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    final search = context.watch<SearchProvider>();
    if (!search.hasActiveFilters) return const SizedBox.shrink();

    final chips = <Widget>[];

    if (search.selectedCategory != 'All') {
      chips.add(_FilterChip(
        label: search.selectedCategory,
        onRemove: () => search.setCategory('All'),
      ));
    }

    if (search.minPrice > 0 || search.maxPrice < search.maxPriceLimit) {
      chips.add(_FilterChip(
        label:
        '\$${search.minPrice.toStringAsFixed(0)} - \$${search.maxPrice.toStringAsFixed(0)}',
        onRemove: () => search.setPriceRange(0, search.maxPriceLimit),
      ));
    }

    if (search.minRating > 0) {
      chips.add(_FilterChip(
        label: '${search.minRating}+ ⭐',
        onRemove: () => search.setMinRating(0),
      ));
    }

    if (search.sortOption != SortOption.relevance) {
      chips.add(_FilterChip(
        label: search.getSortLabel(search.sortOption),
        onRemove: () => search.setSortOption(SortOption.relevance),
      ));
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...chips,
            TextButton(
              onPressed: () => search.clearFilters(),
              child: const Text(
                'Clear All',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _FilterChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              size: 14,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}