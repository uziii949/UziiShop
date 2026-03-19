import 'package:flutter/material.dart';
import 'package:uzii_shop/theme/app_theme.dart';

class FeaturedCollectionData {
  final String title;
  final String subtitle;
  final String emoji;
  final String category;
  final List<int> gradientColors;

  const FeaturedCollectionData({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.category,
    required this.gradientColors,
  });
}

const List<FeaturedCollectionData> featuredCollections = [
  FeaturedCollectionData(
    title: 'Tech Essentials',
    subtitle: 'Latest gadgets',
    emoji: '💻',
    category: 'electronics',
    gradientColors: [0xFF6C5DD3, 0xFF8B7CE8],
  ),
  FeaturedCollectionData(
    title: 'Daily Deals',
    subtitle: 'Top rated items',
    emoji: '🔥',
    category: 'All',
    gradientColors: [0xFFFF6B6B, 0xFFFF9898],
  ),
  FeaturedCollectionData(
    title: 'Jewelry',
    subtitle: 'Premium picks',
    emoji: '💎',
    category: 'jewelery',
    gradientColors: [0xFF1A73E8, 0xFF4DA3FF],
  ),
  FeaturedCollectionData(
    title: "Men's Style",
    subtitle: 'Trending now',
    emoji: '👔',
    category: "men's clothing",
    gradientColors: [0xFF2DC653, 0xFF52D975],
  ),
];

class FeaturedCollectionCard extends StatelessWidget {
  final FeaturedCollectionData data;
  final VoidCallback onTap;

  const FeaturedCollectionCard({
    super.key,
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
            data.gradientColors.map((c) => Color(c)).toList(),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Color(data.gradientColors[0])
                  .withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              data.emoji,
              style: const TextStyle(fontSize: 32),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  data.subtitle,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}