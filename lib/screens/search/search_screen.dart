import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uzii_shop/providers/search_provider.dart';
import 'package:uzii_shop/providers/product_provider.dart';
import 'package:uzii_shop/theme/app_theme.dart';
import 'package:uzii_shop/screens/home/widgets/product_card.dart';
import 'package:uzii_shop/screens/product/product_detail_screen.dart';
import 'package:uzii_shop/screens/search/widgets/empty_search_results_view.dart';
import 'package:uzii_shop/screens/search/widgets/active_filter_chips.dart';
import 'package:uzii_shop/screens/search/widgets/filter_bottom_sheet.dart';
import 'package:uzii_shop/screens/search/widgets/sort_bottom_sheet.dart';
import 'package:uzii_shop/providers/cart_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load products into search provider
      final products = context.read<ProductProvider>().products;
      if (products.isEmpty) {
        context.read<ProductProvider>().fetchProducts().then((_) {
          context.read<SearchProvider>().loadProducts(
            context.read<ProductProvider>().products,
          );
        });
      } else {
        context.read<SearchProvider>().loadProducts(products);
      }
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final search = context.watch<SearchProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          onChanged: (value) =>
              context.read<SearchProvider>().setSearchQuery(value),
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 15,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'Search products...',
            hintStyle: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
            ),
            border: InputBorder.none,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.close,
                  color: AppColors.textSecondary),
              onPressed: () {
                _searchController.clear();
                context
                    .read<SearchProvider>()
                    .setSearchQuery('');
              },
            )
                : null,
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter + Sort row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                // Filter button
                _ActionButton(
                  icon: Icons.tune,
                  label: 'Filter',
                  isActive: search.hasActiveFilters,
                  onTap: () => FilterBottomSheet.show(context),
                ),
                const SizedBox(width: 10),

                // Sort button
                _ActionButton(
                  icon: Icons.sort,
                  label: search.sortOption == SortOption.relevance
                      ? 'Sort'
                      : search.getSortLabel(search.sortOption),
                  isActive: search.sortOption != SortOption.relevance,
                  onTap: () => SortBottomSheet.show(context),
                ),

                const Spacer(),

                // Results count
                Text(
                  '${search.results.length} results',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Active filter chips
          const ActiveFilterChips(),

          // Recent searches (when empty query)
          if (_searchController.text.isEmpty &&
              search.recentSearches.isNotEmpty)
            _RecentSearchesSection(
              searches: search.recentSearches,
              onTap: (query) {
                _searchController.text = query;
                context.read<SearchProvider>().setSearchQuery(query);
              },
              onClear: () =>
                  context.read<SearchProvider>().clearRecentSearches(),
            ),

          // Results
          Expanded(
            child: search.results.isEmpty
                ? const EmptySearchResultsView()
                : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: search.results.length,
              itemBuilder: (context, index) {
                final product = search.results[index];
                return ProductCard(
                  product: product,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ProductDetailScreen(product: product),
                    ),
                  ),
                  onAddToCart: () {
                    context
                        .read<CartProvider>()
                        .addToCart(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Added to cart! 🛒'),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Action Button ──────────────────────────────
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary
              : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.divider,
          ),
          boxShadow: isActive
              ? [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color:
                isActive ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Recent Searches ────────────────────────────
class _RecentSearchesSection extends StatelessWidget {
  final List<String> searches;
  final Function(String) onTap;
  final VoidCallback onClear;

  const _RecentSearchesSection({
    required this.searches,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Searches',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: onClear,
                child: const Text(
                  'Clear',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
          Wrap(
            spacing: 8,
            children: searches.map((s) {
              return GestureDetector(
                onTap: () => onTap(s),
                child: Chip(
                  label: Text(
                    s,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  backgroundColor: AppColors.surface,
                  side: const BorderSide(color: AppColors.divider),
                  avatar: const Icon(
                    Icons.history,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}