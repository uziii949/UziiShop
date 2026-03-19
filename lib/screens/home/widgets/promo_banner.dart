import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:uzii_shop/theme/app_theme.dart';

class PromoBanner extends StatefulWidget {
  const PromoBanner({super.key});

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  int _currentIndex = 0;

  final List<_BannerData> _banners = [
    _BannerData(
      title: 'Big Sale 50% Off!',
      subtitle: 'On all electronics',
      emoji: '⚡',
      gradient: [Color(0xFF6C5DD3), Color(0xFF8B7CE8)],
    ),
    _BannerData(
      title: 'New Collection',
      subtitle: 'Fresh fashion arrivals',
      emoji: '👗',
      gradient: [Color(0xFFFF6B6B), Color(0xFFFF9898)],
    ),
    _BannerData(
      title: 'Free Shipping',
      subtitle: 'On orders over \$50',
      emoji: '🚚',
      gradient: [Color(0xFF2DC653), Color(0xFF52D975)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 160,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 600),
            viewportFraction: 1.0,
            onPageChanged: (index, _) =>
                setState(() => _currentIndex = index),
          ),
          items: _banners.map((banner) => _buildBanner(banner)).toList(),
        ),
        const SizedBox(height: 10),
        // Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _banners.asMap().entries.map((entry) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _currentIndex == entry.key ? 20 : 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: _currentIndex == entry.key
                    ? AppColors.primary
                    : AppColors.divider,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBanner(_BannerData banner) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: banner.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  banner.title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  banner.subtitle,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Shop Now',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            banner.emoji,
            style: const TextStyle(fontSize: 64),
          ),
        ],
      ),
    );
  }
}

class _BannerData {
  final String title;
  final String subtitle;
  final String emoji;
  final List<Color> gradient;

  _BannerData({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.gradient,
  });
}