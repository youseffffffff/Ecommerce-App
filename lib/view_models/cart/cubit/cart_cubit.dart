import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/models/cart.items.model.dart';
import 'package:ecommerce_app/models/product_items_model.dart';
import 'package:meta/meta.dart';
import 'package:ecommerce_app/services/users_services.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final UserService _userService = UserService();
  CartCubit() : super(CartInitial());

  // جلب جميع عناصر السلة من Firestore
  Future<void> fetchCartItems(String userId) async {
    emit(CartLoading());
    try {
      final items = await _userService.getCartItems(userId);
      emit(CartLoaded(items));
    } catch (e) {
      emit(CartError('Failed to load cart items'));
    }
  }

  // إضافة عنصر للسلة في Firestore
  Future<void> addCartItem(String userId, CartItem item) async {
    try {
      await _userService.addCartItem(userId, item);
      fetchCartItems(userId); // تحديث القائمة بعد الإضافة
    } catch (e) {
      emit(CartError('Failed to add cart item'));
    }
  }

  // جلب عنصر واحد من السلة حسب المنتج
  Future<CartItem?> getCartItemByProductId(
    String userId,
    String productId,
  ) async {
    try {
      return await _userService.getCartItemByProductId(userId, productId);
    } catch (e) {
      emit(CartError('Failed to get cart item'));
      return null;
    }
  }

  Future<void> incrementQuantity(
    String userId,
    String id,
    ProductSize size,
  ) async {
    // جلب السلة من فايربيز
    final cartItems = await _userService.getCartItems(userId);
    var index = cartItems.indexWhere(
      (p) => p.product.id == id && p.size == size,
    );
    if (index == -1) return;

    final updatedItem = cartItems[index].copyWith(
      quantity: cartItems[index].quantity + 1,
    );

    await _userService.addCartItem(userId, updatedItem.copyWith(quantity: 1));
    // إعادة جلب السلة بعد التحديث
    final updatedCart = await _userService.getCartItems(userId);

    emit(
      QuantityLoaded(
        items: updatedCart,
        cart: updatedItem,
        quantity: updatedItem.quantity,
      ),
    );
  }

  Future<void> decrementQuantity(
    String userId,
    String id,
    ProductSize size,
  ) async {
    // جلب السلة من فايربيز
    final cartItems = await _userService.getCartItems(userId);

    var index = cartItems.indexWhere(
      (p) => p.product.id == id && p.size == size,
    );

    if (index == -1 || cartItems[index].quantity < 1) return;

    final updatedItem = cartItems[index].copyWith(
      quantity: cartItems[index].quantity - 1,
    );

    await _userService.addCartItem(userId, updatedItem.copyWith(quantity: -1));
    // إعادة جلب السلة بعد التحديث
    final updatedCart = await _userService.getCartItems(userId);

    emit(
      QuantityLoaded(
        items: updatedCart,
        cart: updatedItem,
        quantity: updatedItem.quantity,
      ),
    );

    if (updatedItem.quantity < 1) {
      emit(CartLoaded(updatedCart));
    }
  }
}
