import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/models/cart.items.model.dart';
import 'package:ecommerce_app/models/product_items_model.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  late ProductSize selectedSize = ProductSize.none;
  int quantity = 1;

  void changeFavoriteStatus(Product product) {
    var index = products.indexWhere((p) => p.id == product.id);

    products[index] = products[index].copyWith(
      isFavorite: !products[index].isFavorite,
    );

    emit(ProductFavoriteChanged(product: products[index]));
  }

  void loadProductDetails(int productId) {
    emit(ProductLoading());

    try {
      // Simulate loading product details
      Future.delayed(Duration(seconds: 2), () {
        Product product = products.firstWhere((p) => p.id == productId);

        emit(ProductLoaded(product: product));
      });
    } catch (e) {
      emit(ProductError());
    }
  }

  void incrementQuantity(int id, ProductSize size) {
    quantity++;

    var index = products.indexWhere((p) => p.id == id);

    emit(QuantityLoaded(product: products[index], quantity: quantity));
  }

  void decrementQuantity(int id, ProductSize size) {
    if (quantity > 1) quantity--;

    var index = products.indexWhere((p) => p.id == id);

    emit(QuantityLoaded(product: products[index], quantity: quantity));
  }

  void selectSize(ProductSize size, int id) {
    var index = products.indexWhere((p) => p.id == id);
    this.selectedSize = size;

    emit(SizeSelected(productSize: size, product: products[index]));
  }

  void addToCart(Product product) {
    emit(CartIsAdding());

    // Simulate adding to cart
    Future.delayed(Duration(seconds: 1), () {
      if (cartItems.any(
        (item) => item.product.id == product.id && item.size == selectedSize,
      )) {
        var index = cartItems.indexWhere(
          (item) => item.product.id == product.id && item.size == selectedSize,
        );

        cartItems[index] = cartItems[index].copyWith(
          quantity: cartItems[index].quantity + this.quantity,
        );

        emit(CartIsAdded());
        return;
      }

      cartItems.add(
        CartItem(product: product, quantity: quantity, size: selectedSize),
      );

      emit(CartIsAdded());
    });
  }
}
