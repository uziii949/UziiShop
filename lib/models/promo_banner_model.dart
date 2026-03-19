class PromoBannerModel {
  final String id;
  final String title;
  final String subtitle;
  final String ctaText;
  final String targetCategory;
  final List<int> gradientColors;
  final String emoji;

  const PromoBannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.ctaText,
    required this.targetCategory,
    required this.gradientColors,
    required this.emoji,
  });
}

// Mock banner data
const List<PromoBannerModel> mockBanners = [
  PromoBannerModel(
    id: '1',
    title: 'Mega Sale 50% Off!',
    subtitle: 'On all electronics',
    ctaText: 'Shop Now',
    targetCategory: 'electronics',
    gradientColors: [0xFF6C5DD3, 0xFF8B7CE8],
    emoji: '⚡',
  ),
  PromoBannerModel(
    id: '2',
    title: 'New Arrivals',
    subtitle: 'Fresh fashion collection',
    ctaText: 'Explore',
    targetCategory: "women's clothing",
    gradientColors: [0xFFFF6B6B, 0xFFFF9898],
    emoji: '👗',
  ),
  PromoBannerModel(
    id: '3',
    title: 'Jewelry Sale',
    subtitle: 'Up to 40% off',
    ctaText: 'View Deals',
    targetCategory: 'jewelery',
    gradientColors: [0xFF2DC653, 0xFF52D975],
    emoji: '💎',
  ),
  PromoBannerModel(
    id: '4',
    title: 'Men\'s Fashion',
    subtitle: 'Latest trends',
    ctaText: 'Shop Now',
    targetCategory: "men's clothing",
    gradientColors: [0xFF1A73E8, 0xFF4DA3FF],
    emoji: '👔',
  ),
];