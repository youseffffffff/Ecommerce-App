import 'package:flutter/material.dart';

enum ProductSize {
  S,
  M,
  L,
  // ignore: constant_identifier_names
  XL,
  none,
}

class Product {
  // Convert Product to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'isFavorite': isFavorite,
      'category': category,
      'averageRate': averageRate,
      'description': description,
      'availableSizes': availableSizes?.map((e) => e.toString()).toList(),
      'availableColors': availableColors?.map((e) => e?.value).toList(),
    };
  }

  // Create Product from Map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: (map['price'] is num)
          ? (map['price'] as num).toDouble()
          : double.tryParse(map['price']?.toString() ?? '0') ?? 0,
      isFavorite: map['isFavorite'] ?? false,
      category: map['category'] ?? '',
      averageRate: (map['averageRate'] is num)
          ? (map['averageRate'] as num).toDouble()
          : double.tryParse(map['averageRate']?.toString() ?? '0') ?? 0,
      description: map['description'] ?? '',
      availableSizes: (map['availableSizes'] as List?)
          ?.map((e) {
            if (e == null) return null;
            return ProductSize.values.firstWhere(
              (size) => size.toString() == e,
              orElse: () => ProductSize.none,
            );
          })
          .whereType<ProductSize>()
          .toList(),
      availableColors: (map['availableColors'] as List?)?.map((e) {
        if (e == null) return null;
        return Color(e);
      }).toList(),
    );
  }
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final bool isFavorite;
  final String category;
  final double averageRate;
  final String description;
  final List<ProductSize>? availableSizes;
  final List<Color?>? availableColors;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.isFavorite = false,
    required this.category,
    required this.averageRate,
    this.description =
        "Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World",
    this.availableSizes,
    this.availableColors,
  });

  Product copyWith({
    String? id,
    String? name,
    String? imageUrl,
    double? price,
    bool? isFavorite,
    String? category,
    double? averageRate,
    String? description,
    List<ProductSize>? availableSizes,
    List<Color?>? availableColors,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      isFavorite: isFavorite ?? this.isFavorite,
      category: category ?? this.category,
      averageRate: averageRate ?? this.averageRate,
      description: description ?? this.description,
      availableSizes: availableSizes ?? this.availableSizes,
      availableColors: availableColors ?? this.availableColors,
    );
  }
}

List<Product> products = [
  Product(
    id: '1',
    name: 'Bulova Watch',
    imageUrl:
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
    price: 399,
    category: 'Watch',
    averageRate: 4.8,
    availableColors: [Colors.black, Colors.brown, Colors.grey, Colors.yellow],
    availableSizes: null,
  ),
  Product(
    id: '2',
    name: 'Zala bag',
    imageUrl:
        'https://images.unsplash.com/photo-1491553895911-0055eca6402d?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
    price: 59,
    category: 'Bag',
    averageRate: 4.2,
    availableColors: [Colors.black, Colors.brown, Colors.pink, Colors.red],
  ),
  Product(
    id: '3',
    name: 'Ayta Slippers',
    imageUrl:
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
    price: 19,
    category: 'Slippers',
    averageRate: 4.5,
    availableColors: [Colors.blueGrey, Colors.brown],
  ),
  Product(
    id: '4',
    name: 'Circle Earrings',
    imageUrl:
        'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
    price: 99,
    category: 'Accessories',
    averageRate: 4.6,
    availableColors: [Colors.amber, Colors.grey[400]],
  ),
  Product(
    id: '5',
    name: 'Sheepskin Leather',
    imageUrl:
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
    price: 29,
    category: 'Phone cover',
    averageRate: 4.0,
    availableColors: [
      Colors.black,
      Colors.deepPurple,
      Colors.green,
      Colors.orange,
    ],
  ),
  Product(
    id: '6',
    name: 'Polo Shirt',
    imageUrl:
        'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
    price: 59,
    category: 'Shirt',
    averageRate: 4.9,
    availableSizes: [
      ProductSize.S,
      ProductSize.M,
      ProductSize.L,
      ProductSize.XL,
    ],
    availableColors: [Colors.white, Colors.blueGrey, Colors.brown],
  ),
];
