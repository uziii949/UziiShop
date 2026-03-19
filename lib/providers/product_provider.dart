import 'package:flutter/material.dart';
import 'package:uzii_shop/models/product_model.dart';
import 'package:uzii_shop/services/product_service.dart';

enum ProductStatus { idle, loading, success, error }

class ProductProvider extends ChangeNotifier {
  final ProductService _service = ProductService();

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<String> _categories = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  ProductStatus _status = ProductStatus.idle;
  String _errorMessage = '';

  // Getters
  List<Product> get products => _filteredProducts;
  List<String> get categories => ['All', ..._categories];
  String get selectedCategory => _selectedCategory;
  ProductStatus get status => _status;
  String get errorMessage => _errorMessage;
  bool get isLoading => _status == ProductStatus.loading;

  // Fetch all products and categories
  Future<void> fetchProducts() async {
    _setStatus(ProductStatus.loading);
    try {
      final results = await Future.wait([
        _service.fetchProducts(),
        _service.fetchCategories(),
      ]);

      _allProducts = results[0] as List<Product>;
      _categories = results[1] as List<String>;
      _filteredProducts = _allProducts;
      _setStatus(ProductStatus.success);
    } catch (e) {
      _errorMessage = 'Failed to load products. Check your connection.';
      _setStatus(ProductStatus.error);
    }
  }

  // Filter by category
  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  // Search products
  void searchProducts(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  // Apply both category and search filters
  void _applyFilters() {
    _filteredProducts = _allProducts.where((product) {
      final matchesCategory = _selectedCategory == 'All' ||
          product.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          product.title.toLowerCase().contains(_searchQuery) ||
          product.description.toLowerCase().contains(_searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  // Refresh
  Future<void> refresh() async {
    _allProducts = [];
    _filteredProducts = [];
    _selectedCategory = 'All';
    _searchQuery = '';
    await fetchProducts();
  }

  void _setStatus(ProductStatus status) {
    _status = status;
    notifyListeners();
  }
}