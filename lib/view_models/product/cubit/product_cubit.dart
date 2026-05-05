import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/models/cart.items.model.dart';
import 'package:ecommerce_app/models/product_items_model.dart';
import 'package:ecommerce_app/services/preducts.dart';
import 'package:ecommerce_app/services/users_services.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductService _productService;
  final UserService _userService = UserService();

  ProductCubit({ProductService? productService})
    : _productService = productService ?? ProductService(),
      super(ProductInitial());

  late ProductSize selectedSize = ProductSize.none;
  int quantity = 1;

  void changeFavoriteStatus(Product product) {
    var index = products.indexWhere((p) => p.id == product.id);

    products[index] = products[index].copyWith(
      isFavorite: !products[index].isFavorite,
    );

    emit(ProductFavoriteChanged(product: products[index]));
  }

  Future<Product?> getProductById(String id) async {
    emit(ProductLoading());
    try {
      final product = await _productService.getProductById(id);
      emit(ProductLoaded(product: product!));
      return product;
    } catch (e) {
      emit(ProductError(message: e.toString()));
      return null;
    }
  }

  // Load product details from Firestore
  Future<void> loadProductDetails(String productId) async {
    emit(ProductLoading());
    try {
      final product = await _productService.getProductById(
        productId.toString(),
      );
      if (product != null) {
        emit(ProductLoaded(product: product));
      } else {
        emit(ProductError(message: 'Product not found.'));
      }
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  // Stream all products from Firestore
  Stream<List<Product>> get productsStream =>
      _productService.getProductsStream();

  // Add or update a product in Firestore
  Future<void> upsertProduct(Product product) async {
    emit(ProductLoading());
    try {
      await _productService.upsertProduct(product);
      emit(ProductLoaded(product: product));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  // Delete a product from Firestore
  Future<void> deleteProduct(String productId) async {
    emit(ProductLoading());
    try {
      await _productService.deleteProduct(productId);
      emit(ProductInitial());
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> addNewProduct(Product product) async {
    emit(ProductLoading());
    try {
      await _productService.upsertProduct(
        product.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString()),
      );
      emit(ProductLoaded(product: product));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  void incrementQuantity(String id, ProductSize size) {
    quantity++;

    emit(QuantityLoaded(quantity: quantity));
  }

  void decrementQuantity(String id, ProductSize size) {
    if (quantity > 1) quantity--;

    emit(QuantityLoaded(quantity: quantity));
  }

  void selectSize(ProductSize size, String id) {
    this.selectedSize = size;

    emit(SizeSelected(productSize: size));
  }

  Future<void> addToCart(Product product, String userId) async {
    emit(CartIsAdding());
    try {
      final cartItem = CartItem(
        product: product,
        quantity: quantity,
        size: selectedSize,
      );
      await _userService.addCartItem(userId, cartItem);
      emit(CartIsAdded());
    } catch (e) {
      emit(ProductError(message: 'فشل في إضافة المنتج للسلة: ${e.toString()}'));
    }
  }
}
