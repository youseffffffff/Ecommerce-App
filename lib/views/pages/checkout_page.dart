import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/models/address.dart';
import 'package:ecommerce_app/models/paymentMethod.model.dart';
import 'package:ecommerce_app/utils/App_Routes.dart';
import 'package:ecommerce_app/utils/current_user.dart';
import 'package:ecommerce_app/views/widgets/empty_PaymentMethodOrAddress_Widget.dart';
import 'package:ecommerce_app/views/widgets/full_Address_Widget.dart';
import 'package:ecommerce_app/views/widgets/full_PaymentMethod_Widget.dart';
import 'package:ecommerce_app/views/widgets/paymentMethods_Widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/utils/app_colors.dart';
import 'package:ecommerce_app/view_models/checkout/cubit/checkout_cubit.dart';

class CheckoutWidget extends StatefulWidget {
  const CheckoutWidget({super.key});

  @override
  State<CheckoutWidget> createState() => _CheckoutWidgetState();
}

class _CheckoutWidgetState extends State<CheckoutWidget> {
  String? selectedAddress;
  String? selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final checkoutCubit = BlocProvider.of<CheckoutCubit>(context);

    Widget addressWidget({required Address? address}) {
      if (address == null) {
        return button_Empty(
          onClick: () {
            Navigator.of(context, rootNavigator: true)
                .pushNamed(AppRoutes.address)
                .then(
                  (value) async => await checkoutCubit.loadCheckoutFromServer(
                    currentUser!.id,
                  ),
                );
            //checkoutCubit.loadCheckout();
          },
          title: 'Add new address',
        );
      } else {
        return adButton_Full(
          trealing: const Icon(Icons.arrow_right_alt_sharp),
          onClick: () {
            Navigator.of(context, rootNavigator: true)
                .pushNamed(AppRoutes.address)
                .then(
                  (value) async => await checkoutCubit.loadCheckoutFromServer(
                    currentUser!.id,
                  ),
                );
          },

          //checkoutCubit.loadCheckout();
          address: address,
          bgColor: AppColors.transparent,
        );
      }
    }

    Widget paymentMethodWidget({required PaymentMethod? method}) {
      if (method == null) {
        return button_Empty(
          onClick: () {
            Navigator.of(context, rootNavigator: true)
                .pushNamed(AppRoutes.paymentMethod)
                .then(
                  (value) async => await checkoutCubit.loadCheckoutFromServer(
                    currentUser!.id,
                  ),
                );
            //checkoutCubit.loadCheckout();
          },
          title: 'Add new payment',
        );
      } else {
        return pyButton_Full(
          trealing: const Icon(Icons.arrow_right_alt_sharp),
          onClick: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return SizedBox(
                  height: size.height * 0.65,
                  width: double.infinity,
                  child: const PaymentMethodsItems(),
                );
              },
            ).then(
              (value) async =>
                  await checkoutCubit.loadCheckoutFromServer(currentUser!.id),
            );
            //checkoutCubit.loadCheckout();
          },
          method: method,
          bgColor: AppColors.grey100,
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.black,
        elevation: 0,
      ),
      body: BlocConsumer<CheckoutCubit, CheckoutState>(
        buildWhen: (previous, current) =>
            current is CheckoutLoading ||
            current is CheckoutError ||
            current is CheckoutLoaded,
        builder: (context, state) {
          if (state is CheckoutLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CheckoutError) {
            return Center(child: Text(state.message));
          } else if (state is CheckoutLoaded) {
            final items = state.Items;
            final paymentMethods = state.Paymentmethods;
            final addresses = state.addresses;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Address",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Edit",
                          style: TextStyle(color: AppColors.purple),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  addressWidget(
                    address: addresses.isEmpty
                        ? null
                        : addresses.firstWhere(
                            (item) => item.isChosen,
                            orElse: () => addresses.first,
                          ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    "Products (${items.length})",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final cartItem = items[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.grey100,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: cartItem.product.imageUrl,
                                  fit: BoxFit.cover,

                                  errorWidget: (context, error, stackTrace) {
                                    return Container(
                                      color: AppColors.grey100,
                                      child: const Icon(
                                        Icons.image_not_supported,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartItem.product.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Qty: ${cartItem.quantity}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "\$${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Payment Methods",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  paymentMethodWidget(
                    method: paymentMethods.isEmpty
                        ? null
                        : paymentMethods.firstWhere(
                            (item) => item.isChosen,
                            orElse: () => paymentMethods.first,
                          ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall!.copyWith(color: AppColors.grey),
                      ),
                      Text(
                        '${state.totalAmount.toString()}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.purple,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Proceed to Buy",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            );
          }
          return Container();
        },

        listenWhen: (previous, current) => current is CheckoutLoaded,
        listener: (context, state) {
          debugPrint("123456789");
        },
      ),
    );
  }
}
