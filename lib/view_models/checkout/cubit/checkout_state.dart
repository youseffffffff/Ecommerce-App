part of 'checkout_cubit.dart';

@immutable
sealed class CheckoutState {}

final class CheckoutInitial extends CheckoutState {}

final class CheckoutLoading extends CheckoutState {}

final class CheckoutLoaded extends CheckoutState {
  final List<CartItem> Items;
  final double totalAmount;
  final List<PaymentMethod> Paymentmethods;
  final List<Address> addresses;

  CheckoutLoaded({
    required this.Items,
    required this.totalAmount,
    required this.Paymentmethods,
    required this.addresses,
  });
}

final class CheckoutError extends CheckoutState {
  final String message;

  CheckoutError(this.message);
}

final class PaymentMethodsLoading extends CheckoutState {}

final class PaymentMethodsLoaded extends CheckoutState {
  final List<PaymentMethod> paymentmethod;

  PaymentMethodsLoaded({required this.paymentmethod});
}

final class PaymentMethodAdding extends CheckoutState {}

final class PaymentMethodAdded extends CheckoutState {}

final class PaymentMethodField extends CheckoutState {
  final String messageError;

  PaymentMethodField({required this.messageError});
}

final class PaymentMethodChoosing extends CheckoutState {}

final class PaymentMethodChoosen extends CheckoutState {
  final PaymentMethod paymentMethod;

  PaymentMethodChoosen({required this.paymentMethod});
}

final class PaymentMethodChanged extends CheckoutState {
  final String currentCardId;

  PaymentMethodChanged({required this.currentCardId});
}

final class AddressLoading extends CheckoutState {}

final class AddressLoaded extends CheckoutState {
  final List<Address> addresses;

  AddressLoaded({required this.addresses});
}

final class AddressAdding extends CheckoutState {}

final class AddressAdded extends CheckoutState {}

final class AddressField extends CheckoutState {
  final String messageError;

  AddressField({required this.messageError});
}

final class AddressChoosing extends CheckoutState {}

final class AddressChoosen extends CheckoutState {
  final Address address;

  AddressChoosen({required this.address});
}

final class AddressChanged extends CheckoutState {
  final String addressId;

  AddressChanged({required this.addressId});
}
