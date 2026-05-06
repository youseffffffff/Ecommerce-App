import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/models/address.dart';
import 'package:ecommerce_app/models/cart.items.model.dart';
import 'package:ecommerce_app/models/order.dart';
import 'package:ecommerce_app/models/paymentMethod.model.dart';
import 'package:ecommerce_app/models/product_items_model.dart';
import 'package:ecommerce_app/utils/current_user.dart';
import 'package:meta/meta.dart';
import 'package:ecommerce_app/services/users_services.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final UserService _userService = UserService();
  CheckoutCubit() : super(CheckoutInitial());

  String currentCardId = '';
  String currentAddressId = '0';

  Future<void> loadCheckoutFromServer(String userId) async {
    emit(CheckoutLoading());
    try {
      final cartItems = await _userService.getCartItems(userId);
      final addresses = await _userService.getAllAddresses(userId);
      final cards = await _userService.getAllCards(userId);
      double subTotalAmount = cartItems.fold(
        0.0,
        (total, item) => total + item.quantity * item.product.price,
      );
      emit(
        CheckoutLoaded(
          Items: cartItems,
          totalAmount: subTotalAmount + 10,
          Paymentmethods: cards,
          addresses: addresses,
        ),
      );
    } catch (e) {
      emit(CheckoutError(message: 'فشل تحميل السلة: ${e.toString()}'));
    }
  }

  Future<void> addPayemntMethod({
    required String userId,
    required PaymentMethod method,
  }) async {
    emit(PaymentMethodAdding());
    try {
      await _userService.addNewCard(userId, method);
      emit(PaymentMethodAdded());
      await loadPaymentMethod(userId: userId);
    } catch (e) {
      emit(CheckoutError(message: 'فشل إضافة البطاقة: ${e.toString()}'));
    }
  }

  Future<void> loadPaymentMethod({required String userId}) async {
    emit(PaymentMethodsLoading());
    try {
      final cards = await _userService.getAllCards(userId);
      emit(PaymentMethodsLoaded(paymentmethod: cards));
    } catch (e) {
      emit(CheckoutError(message: 'فشل تحميل البطاقات: ${e.toString()}'));
    }
  }

  Future<void> addOrder(UserOrder order) async {
    emit(OrderPaying());
    try {
      await _userService.addNewOrder(order);
      emit(OrderPayed());
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }

  void changeCardChosen(String Id) {
    currentCardId = Id;
    emit(PaymentMethodChanged(currentCardId: Id));
  }

  Future<void> confirmCardChosen({required String userId}) async {
    emit(PaymentMethodChoosing());
    try {
      final cards = await _userService.getAllCards(userId);
      int current = cards.indexWhere((method) => method.Id == currentCardId);
      int previes = cards.indexWhere((method) => method.isChosen);
      previes = previes == -1 ? 0 : previes;

      // Update chosen state in Firestore
      for (int i = 0; i < cards.length; i++) {
        final updated = cards[i].copyWith(isChosen: i == current);
        await _userService.addNewCard(userId, updated);
      }

      final updatedCards = await _userService.getAllCards(userId);
      emit(PaymentMethodChoosen(paymentMethod: updatedCards[current]));
      emit(PaymentMethodsLoaded(paymentmethod: updatedCards));
    } catch (e) {
      emit(CheckoutError(message: 'فشل تأكيد البطاقة: ${e.toString()}'));
    }
  }

  Future<void> loadAddress(String userId) async {
    emit(AddressLoading());

    try {
      final addresses = await _userService.getAllAddresses(userId);
      emit(AddressLoaded(addresses: addresses));
    } catch (e) {
      emit(AddressError(message: e.toString()));
    }
  }

  // 🔹 ADD (عن طريق service)
  Future<void> addAddress({required String address}) async {
    emit(AddressAdding());

    try {
      final split = address.split('-');

      final addressItem = Address(
        id: DateTime.now().toIso8601String(),
        city: split[0],
        country: split[1],
      );

      await _userService.addNewAddress(currentUser!.id, addressItem);

      final updated = await _userService.getAllAddresses(currentUser!.id);

      emit(AddressAdded());
      emit(AddressLoaded(addresses: updated));
    } catch (e) {
      emit(AddressError(message: e.toString()));
    }
  }

  // 🔹 DELETE
  Future<void> deleteAddress(String addressId) async {
    try {
      await _userService.deleteAddress(currentUser!.id, addressId);

      final updated = await _userService.getAllAddresses(currentUser!.id);

      emit(AddressLoaded(addresses: updated));
    } catch (e) {
      emit(AddressError(message: e.toString()));
    }
  }

  // 🔹 اختيار مؤقت
  void changeAddressChosen(String id) {
    currentAddressId = id;
    emit(AddressChanged(addressId: id));
  }

  // 🔥 CONFIRM (عن طريق service فقط)
  Future<void> confirmAddressChosen({required String userId}) async {
    emit(AddressChoosing());

    try {
      final List<Address> addresses = await _userService.getAllAddresses(
        userId,
      );

      for (var address in addresses) {
        final updated = address.copyWith(
          isChosen: address.id == currentAddressId,
        );

        await _userService.addNewAddress(currentUser!.id, updated);
      }

      final List<Address> updatedList = await _userService.getAllAddresses(
        currentUser!.id,
      );

      final chosen = updatedList.firstWhere((a) => a.id == currentAddressId);

      emit(AddressChoosen(addressId: chosen.id));
      emit(AddressLoaded(addresses: updatedList));
    } catch (e) {
      emit(AddressError(message: e.toString()));
    }

    // void addAddress({required String address}) {
    //   emit(AddressAdding());

    //   Future.delayed(Duration(seconds: 2), () {
    //     final splitAddres = address.split('-');

    //     final addressItem = Address(
    //       id: DateTime.now().toIso8601String(),
    //       city: splitAddres[0],
    //       country: splitAddres[1],
    //     );
    //     addresses.add(addressItem);

    //     emit(AddressAdded());
    //     emit(AddressLoaded(addresses: addresses));
    //   });
    // }

    // void loadAddress() {
    //   emit(AddressLoading());

    //   Future.delayed(Duration(seconds: 2), () {
    //     emit(AddressLoaded(addresses: addresses));
    //   });
    // }

    // void changeAddressChosen(String Id) {
    //   currentAddressId = Id;
    //   emit(AddressChanged(addressId: Id));
    // }

    // void confirmAddressChosen() {
    //   emit(AddressChoosing());

    //   Future.delayed(Duration(seconds: 2), () {
    //     int current = addresses.indexWhere(
    //       (address) => address.id == currentAddressId,
    //     );

    //     int previes = addresses.indexWhere((address) => address.isChosen);

    //     previes = previes == -1 ? 0 : previes;

    //     addresses[current] = addresses[current].copyWith(isChosen: true);

    //     addresses[previes] = addresses[previes].copyWith(isChosen: false);

    //     emit(AddressChoosen(address: addresses[current]));
    //   });
    // }
  }
}
