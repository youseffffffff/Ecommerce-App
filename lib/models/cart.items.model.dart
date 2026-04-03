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
}

List<CartItem> cartItems = [
  CartItem(
    product: Product(
      id: 6,
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
    quantity: 3,
    size: ProductSize.S,
  ),
];
