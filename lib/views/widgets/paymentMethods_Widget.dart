import 'package:ecommerce_app/utils/App_Routes.dart';
import 'package:ecommerce_app/utils/app_colors.dart';
import 'package:ecommerce_app/view_models/checkout/cubit/checkout_cubit.dart';
import 'package:ecommerce_app/views/widgets/full_PaymentMethod_Widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentMethodsItems extends StatefulWidget {
  const PaymentMethodsItems({super.key});

  @override
  State<PaymentMethodsItems> createState() => _PaymentMethodsItemsState();
}

class _PaymentMethodsItemsState extends State<PaymentMethodsItems> {
  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<CheckoutCubit>(context);
    final size = MediaQuery.of(context).size;
    cubit.loadPaymentMethod();

    return BlocBuilder<CheckoutCubit, CheckoutState>(
      bloc: cubit,
      buildWhen: (previous, current) =>
          current is PaymentMethodsLoaded || current is PaymentMethodsLoading,
      builder: (context, state) {
        if (state is PaymentMethodsLoaded) {
          final methods = state.paymentmethod;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BlocBuilder<CheckoutCubit, CheckoutState>(
                      bloc: cubit,

                      buildWhen: (previous, current) =>
                          current is PaymentMethodsLoaded ||
                          current is PaymentMethodChanged,

                      builder: (context, state) {
                        if (state is PaymentMethodsLoaded) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: methods.length,
                            itemBuilder: (context, index) {
                              final method = methods[index];
                              return Card(
                                elevation: 0.5,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: pyButton_Full(
                                    method: method,
                                    onClick: () {
                                      cubit.changeCardChosen(method.Id);
                                    },
                                    bgColor: AppColors.grey100,
                                    trealing: Radio<String>(
                                      value: method.Id,
                                      groupValue: methods
                                          .firstWhere(
                                            (m) => m.isChosen,
                                            orElse: () => methods[0],
                                          )
                                          .Id,
                                      onChanged: (value) {
                                        if (value != null) {
                                          cubit.changeCardChosen(value);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (state is PaymentMethodChanged) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: methods.length,
                            itemBuilder: (context, index) {
                              final method = methods[index];
                              return Card(
                                elevation: 0.5,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: pyButton_Full(
                                    method: method,
                                    onClick: () {
                                      cubit.changeCardChosen(method.Id);
                                    },
                                    bgColor: AppColors.grey100,
                                    trealing: Radio<String>(
                                      value: method.Id,
                                      groupValue: state.currentCardId,

                                      onChanged: (value) {
                                        if (value != null) {
                                          cubit.changeCardChosen(value);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                    SizedBox(height: size.height * 0.05),
                    InkWell(
                      onTap: () {
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pushNamed(AppRoutes.paymentMethod).then((value) {
                          cubit.loadPaymentMethod();
                        });
                      },
                      child: Card(
                        color: AppColors.grey300,
                        elevation: 4,
                        child: const ListTile(
                          leading: Icon(Icons.add_card),
                          title: Text(
                            "Add New Payment Method",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        cubit.confirmCardChosen();
                        Navigator.of(context).pop();
                      },
                      child: Card(
                        color: AppColors.purple,
                        elevation: 4,
                        child: const ListTile(
                          leading: Icon(Icons.check_box, color: Colors.white),
                          title: Text(
                            "Confirm The Current Card",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
      },
    );
  }
}
