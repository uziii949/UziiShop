import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:uzii_shop/models/promo_banner_model.dart';
import 'package:uzii_shop/theme/app_theme.dart';

class HeroBannerCarousel extends StatefulWidget {
  final Function(String category) onBannerTap;

  const HeroBannerCarousel({super.key, required this.onBannerTap});

  @override
  State<HeroBannerCarousel> createState() => _HeroBannerCarouselState();
}

class _HeroBannerCarouselState extends State<HeroBannerCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 180,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration:
            const Duration(milliseconds: 600),
            viewportFraction: 1.0,
            onPageChanged: (index, _) =>
                setState(() => _currentIndex = index),
          ),
          items: mockBanners.map((banner) {
            return GestureDetector(
              onTap: () => widget.onBannerTap(banner.targetCategory),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: banner.gradientColors
                        .map((c) => Color(c))
                        .toList(),
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color(banner.gradientColors[0])
                          .withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
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
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            banner.subtitle,
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 13,
                              color:
                              Colors.white.withValues(alpha: 0.85),
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
                            child: Text(
                              banner.ctaText,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(banner.gradientColors[0]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      banner.emoji,
                      style: const TextStyle(fontSize: 70),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),

        // Page indicator
        AnimatedSmoothIndicator(
          activeIndex: _currentIndex,
          count: mockBanners.length,
          effect: ExpandingDotsEffect(
            activeDotColor: AppColors.primary,
            dotColor: AppColors.divider,
            dotHeight: 6,
            dotWidth: 6,
            expansionFactor: 3,
          ),
        ),
      ],
    );
  }
}