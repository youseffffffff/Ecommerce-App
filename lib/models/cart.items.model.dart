import 'package:ecommerce_app/models/product_items_model.dart';
import 'package:flutter/material.dart';

class CartItem {
  final Product product;
  final ProductSize size;
  final int quantity;

  CartItem({required this.product, required this.quantity, required this.size});

  CartItem copyWith({Product? product, ProductSize? size, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      size: size ?? this.size,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'size': size.toString(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product: Product.fromMap(map['product'] as Map<String, dynamic>),
      size: ProductSize.values.firstWhere(
        (e) => e.toString() == map['size'],
        orElse: () => ProductSize.none,
      ),
      quantity: map['quantity'] ?? 1,
    );
  }
}
