class CartItem {
  final int productId;
  final String title;
  final String image;
  final double price;
  final String category;
  int quantity;

  CartItem({
    required this.productId,
    required this.title,
    required this.image,
    required this.price,
    required this.category,
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;

  // Convert to JSON for SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'image': image,
      'price': price,
      'category': category,
      'quantity': quantity,
    };
  }

  // Create from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'],
      title: json['title'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
      category: json['category'],
      quantity: json['quantity'],
    );
  }

  CartItem copyWith({int? quantity}) {
    return CartItem(
      productId: productId,
      title: title,
      image: image,
      price: price,
      category: category,
      quantity: quantity ?? this.quantity,
    );
  }
}