part of 'product_cubit.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}

final class ProductLoading extends ProductState {}

final class ProductLoaded extends ProductState {
  Product product;

  ProductLoaded({required this.product});
}

final class ProductError extends ProductState {
  final String message;

  ProductError({
    this.message = "An error occurred while loading product details.",
  });
}

final class ProductFavoriteChanged extends ProductState {
  final Product product;

  ProductFavoriteChanged({required this.product});
}

final class QuantityLoaded extends ProductState {
  final Product product;
  final int quantity;

  QuantityLoaded({required this.product, required this.quantity});
}

final class SizeSelected extends ProductState {
  final ProductSize productSize;
  final Product product;

  SizeSelected({required this.productSize, required this.product});
}

final class CartIsAdding extends ProductState {}

final class CartIsAdded extends ProductState {}
