part of 'cart_cubit.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartLoaded extends CartState {
  final List<CartItem> items;

  CartLoaded(this.items);
}

final class CartError extends CartState {
  final String message;

  CartError(this.message);
}

final class QuantityLoaded extends CartState {
  final List<CartItem> items;

  final CartItem cart;
  final int quantity;

  QuantityLoaded({
    required this.items,
    required this.cart,
    required this.quantity,
  });
}
