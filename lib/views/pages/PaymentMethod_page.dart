import 'package:ecommerce_app/models/paymentMethod.model.dart';
import 'package:ecommerce_app/view_models/checkout/cubit/checkout_cubit.dart';
import 'package:ecommerce_app/views/widgets/customTextForm.dart';
import 'package:ecommerce_app/views/widgets/main_mutton_Widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({super.key});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _nameOnCardController,
      _expireDateController,
      _cardNumberController,
      _cvvController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _nameOnCardController = TextEditingController();
    _expireDateController = TextEditingController();
    _cardNumberController = TextEditingController();
    _cvvController = TextEditingController();
  }

  @override
  void dispose() {
    _nameOnCardController.dispose();
    _expireDateController.dispose();
    _cardNumberController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final checkoutCubit = BlocProvider.of<CheckoutCubit>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Add New Card',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SizedBox(
        height: size.height * 0.7,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            child: Column(
              children: [
                const SizedBox(height: 24.0),
                TextFormField(
                  controller: _nameOnCardController,
                  keyboardType: TextInputType.name,
                  validator: (value) => value != null && value.isEmpty
                      ? 'Please enter your name'
                      : null,
                  decoration: const InputDecoration(
                    labelText: 'Name on Card',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _cardNumberController,
                  validator: (value) => value != null && value.isEmpty
                      ? 'Please enter your card number'
                      : null,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    String newValue = value.replaceAll('-', '');
                    if (newValue.length % 4 == 0 && newValue.length < 16) {
                      _cardNumberController.text += '-';
                    }
                    if (value.length >= 20) {
                      _cardNumberController.text = value.substring(0, 19);
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Card Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _expireDateController,
                  validator: (value) => value != null && value.isEmpty
                      ? 'Please enter your expire date'
                      : null,
                  keyboardType: TextInputType.datetime,
                  onChanged: (value) {
                    if (value.length == 2 && !value.contains('/')) {
                      _expireDateController.text += '/';
                    }
                    if (value.length == 6 && value.contains('/')) {
                      _expireDateController.text = value.substring(0, 5);
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Expire Date',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _cvvController,
                  validator: (value) => value != null && value.isEmpty
                      ? 'Please enter your CVV'
                      : null,
                  onChanged: (value) {
                    if (value.length >= 3) {
                      _cvvController.text = value.substring(0, 3);
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'CVV',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 36.0),
                SizedBox(
                  width: double.infinity,
                  child: BlocConsumer<CheckoutCubit, CheckoutState>(
                    bloc: checkoutCubit,

                    listenWhen: (previous, current) =>
                        current is PaymentMethodAdded,
                    buildWhen: (previous, current) =>
                        current is PaymentMethodAdded ||
                        current is PaymentMethodAdded ||
                        current is PaymentMethodsLoaded,

                    listener: (context, state) {
                      if (state is PaymentMethodAdded) {
                        Navigator.of(context).pop();
                      }
                    },
                    builder: (context, state) {
                      if (state is PaymentMethodAdding) {
                        return MainButton(
                          onTap: null,
                          child: const CircularProgressIndicator.adaptive(),
                        );
                      }
                      return MainButton(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            final paymentMethod = PaymentMethod(
                              Id: DateTime.now().toIso8601String(),
                              CardHolderName: _nameOnCardController.text,
                              CardNumber: _cardNumberController.text,
                              ExpiryDate: _expireDateController.text,
                              Cvv: _cvvController.text,
                            );
                            checkoutCubit.addPayemntMethod(
                              method: paymentMethod,
                            );
                          }
                        },
                        text: 'Add Card',
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
