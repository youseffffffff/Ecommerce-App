import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/models/address.dart';
import 'package:ecommerce_app/models/cart.items.model.dart';
import 'package:ecommerce_app/models/paymentMethod.model.dart';
import 'package:meta/meta.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());

  String currentCardId = paymentMethods.first.Id;
  String currentAddressId = addresses.first.id;

  void loadCheckout() {
    emit(CheckoutLoading());

    Future.delayed(Duration(seconds: 2), () {
      double subTotalAmount = cartItems.fold(
        0.0,
        (total, item) => total + item.quantity * item.product.price,
      );

      emit(
        CheckoutLoaded(
          Items: cartItems,
          totalAmount: subTotalAmount + 10,
          Paymentmethods: paymentMethods,
          addresses: addresses,
        ),
      );
    });
  }

  void addPayemntMethod({required PaymentMethod method}) {
    emit(PaymentMethodAdding());

    Future.delayed(Duration(seconds: 2), () {
      paymentMethods.add(method);

      emit(PaymentMethodAdded());
    });
  }

  void loadPaymentMethod() {
    emit(PaymentMethodsLoading());

    Future.delayed(Duration(seconds: 2), () {
      emit(PaymentMethodsLoaded(paymentmethod: paymentMethods));
    });
  }

  void changeCardChosen(String Id) {
    currentCardId = Id;
    emit(PaymentMethodChanged(currentCardId: Id));
  }

  void confirmCardChosen() {
    emit(PaymentMethodChoosing());
    Future.delayed(Duration(seconds: 2), () {
      int current = paymentMethods.indexWhere(
        (method) => method.Id == currentCardId,
      );
      int previes = paymentMethods.indexWhere((method) => method.isChosen);

      previes = previes == -1 ? 0 : previes;

      paymentMethods[current] = paymentMethods[current].copyWith(
        isChosen: true,
      );
      paymentMethods[previes] = paymentMethods[previes].copyWith(
        isChosen: false,
      );

      emit(PaymentMethodChoosen(paymentMethod: paymentMethods[current]));
    });
  }

  void addAddress({required String address}) {
    emit(AddressAdding());

    Future.delayed(Duration(seconds: 2), () {
      final splitAddres = address.split('-');

      final addressItem = Address(
        id: DateTime.now().toIso8601String(),
        city: splitAddres[0],
        country: splitAddres[1],
      );
      addresses.add(addressItem);

      emit(AddressAdded());
      emit(AddressLoaded(addresses: addresses));
    });
  }

  void loadAddress() {
    emit(AddressLoading());

    Future.delayed(Duration(seconds: 2), () {
      emit(AddressLoaded(addresses: addresses));
    });
  }

  void changeAddressChosen(String Id) {
    currentAddressId = Id;
    emit(AddressChanged(addressId: Id));
  }

  void confirmAddressChosen() {
    emit(AddressChoosing());

    Future.delayed(Duration(seconds: 2), () {
      int current = addresses.indexWhere(
        (address) => address.id == currentAddressId,
      );

      int previes = addresses.indexWhere((address) => address.isChosen);

      previes = previes == -1 ? 0 : previes;

      addresses[current] = addresses[current].copyWith(isChosen: true);

      addresses[previes] = addresses[previes].copyWith(isChosen: false);

      emit(AddressChoosen(address: addresses[current]));
    });
  }
}
