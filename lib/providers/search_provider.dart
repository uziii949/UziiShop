import 'package:flutter/material.dart';
import 'package:uzii_shop/models/product_model.dart';

enum SortOption {
  relevance,
  priceLowToHigh,
  priceHighToLow,
  highestRated,
  nameAtoZ,
}

class SearchProvider extends ChangeNotifier {
  List<Product> _allProducts = [];
  List<Product> _results = [];
  List<String> _recentSearches = [];

  String _searchQuery = '';
  String _selectedCategory = 'All';
  double _minPrice = 0;
  double _maxPrice = 1000;
  double _maxPriceLimit = 1000;
  double _minRating = 0;
  SortOption _sortOption = SortOption.relevance;
  bool _isLoading = false;

  // Getters
  List<Product> get results => _results;
  List<String> get recentSearches => _recentSearches;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  double get maxPriceLimit => _maxPriceLimit;
  double get minRating => _minRating;
  SortOption get sortOption => _sortOption;
  bool get isLoading => _isLoading;
  bool get hasResults => _results.isNotEmpty;
  bool get hasActiveFilters =>
      _selectedCategory != 'All' ||
          _minPrice > 0 ||
          _maxPrice < _maxPriceLimit ||
          _minRating > 0 ||
          _sortOption != SortOption.relevance;

  // Load products
  void loadProducts(List<Product> products) {
    _allProducts = products;
    _maxPriceLimit = products.isEmpty
        ? 1000
        : products.map((p) => p.price).reduce((a, b) => a > b ? a : b);
    _maxPrice = _maxPriceLimit;
    _applyAll();
  }

  // Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    if (query.isNotEmpty && !_recentSearches.contains(query)) {
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 5) {
        _recentSearches = _recentSearches.sublist(0, 5);
      }
    }
    _applyAll();
  }

  // Set category
  void setCategory(String category) {
    _selectedCategory = category;
    _applyAll();
  }

  // Set price range
  void setPriceRange(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    _applyAll();
  }

  // Set min rating
  void setMinRating(double rating) {
    _minRating = rating;
    _applyAll();
  }

  // Set sort option
  void setSortOption(SortOption option) {
    _sortOption = option;
    _applyAll();
  }

  // Clear filters (keep search query)
  void clearFilters() {
    _selectedCategory = 'All';
    _minPrice = 0;
    _maxPrice = _maxPriceLimit;
    _minRating = 0;
    _sortOption = SortOption.relevance;
    _applyAll();
  }

  // Clear recent searches
  void clearRecentSearches() {
    _recentSearches.clear();
    notifyListeners();
  }

  // Apply all filters + sort
  void _applyAll() {
    List<Product> filtered = List.from(_allProducts);

    // Search
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((p) =>
      p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.description.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    // Category
    if (_selectedCategory != 'All') {
      filtered = filtered.where((p) => p.category == _selectedCategory).toList();
    }

    // Price range
    filtered = filtered.where((p) =>
    p.price >= _minPrice && p.price <= _maxPrice).toList();

    // Rating
    if (_minRating > 0) {
      filtered = filtered.where((p) => p.rating.rate >= _minRating).toList();
    }

    // Sort
    switch (_sortOption) {
      case SortOption.priceLowToHigh:
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceHighToLow:
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.highestRated:
        filtered.sort((a, b) => b.rating.rate.compareTo(a.rating.rate));
        break;
      case SortOption.nameAtoZ:
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortOption.relevance:
        break;
    }

    _results = filtered;
    notifyListeners();
  }

  String getSortLabel(SortOption option) {
    switch (option) {
      case SortOption.relevance:
        return 'Relevance';
      case SortOption.priceLowToHigh:
        return 'Price: Low to High';
      case SortOption.priceHighToLow:
        return 'Price: High to Low';
      case SortOption.highestRated:
        return 'Highest Rated';
      case SortOption.nameAtoZ:
        return 'Name: A to Z';
    }
  }
}