import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/models/cart.items.model.dart';
import 'package:ecommerce_app/models/product_items_model.dart';
import 'package:meta/meta.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  void getCartItems() {
    emit(CartLoading());
    try {
      // Simulate fetching cart items from a repository or API
      Future.delayed(Duration(seconds: 1), () {
        emit(CartLoaded(cartItems));
      });
    } catch (e) {
      emit(CartError('Failed to load cart items'));
    }
  }

  void incrementQuantity(int id, ProductSize size) {
    var index = cartItems.indexWhere(
      (p) => p.product.id == id && p.size == size,
    );

    cartItems[index] = cartItems[index].copyWith(
      quantity: cartItems[index].quantity + 1,
    );

    emit(
      QuantityLoaded(
        items: cartItems,
        cart: cartItems[index],
        quantity: cartItems[index].quantity,
      ),
    );
  }

  void decrementQuantity(int id, ProductSize size) {
    var index = cartItems.indexWhere(
      (p) => p.product.id == id && p.size == size,
    );
    if (cartItems[index].quantity > 1)
      cartItems[index] = cartItems[index].copyWith(
        quantity: cartItems[index].quantity - 1,
      );

    emit(
      QuantityLoaded(
        items: cartItems,
        cart: cartItems[index],
        quantity: cartItems[index].quantity,
      ),
    );
  }
}
