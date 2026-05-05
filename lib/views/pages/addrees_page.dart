import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/models/address.dart';
import 'package:ecommerce_app/utils/app_colors.dart';
import 'package:ecommerce_app/view_models/checkout/cubit/checkout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  @override
  Widget build(BuildContext context) {
    Widget addressWidget({
      required Address address,
      bool selected = false,
      required onTap,
    }) {
      return InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),

          child: DecoratedBox(
            decoration: BoxDecoration(
              border: BoxBorder.all(width: 1, color: AppColors.grey),
              borderRadius: BorderRadius.circular(16),
            ),

            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusGeometry.all(Radius.circular(16)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          address.country,
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${address.country}, ${address.city}',
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(color: AppColors.grey),
                        ),
                      ],
                    ),
                    Stack(
                      alignment: AlignmentGeometry.center,

                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 50,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(63),
                              color: selected
                                  ? AppColors.purple
                                  : AppColors.transparent,
                            ),
                          ),
                        ),

                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 48,
                          child: CachedNetworkImage(
                            imageUrl: address.imgUrl,
                            fit: BoxFit.cover,

                            errorWidget: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.grey100,
                                child: const Icon(Icons.image_not_supported),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    final cubit = BlocProvider.of<CheckoutCubit>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Address Page'), centerTitle: true),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 32),
          child: BlocBuilder<CheckoutCubit, CheckoutState>(
            bloc: cubit,
            buildWhen: (previous, current) =>
                current is AddressLoaded ||
                current is AddressLoading ||
                current is AddressError,
            builder: (context, state) {
              if (state is AddressLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is AddressError) {
                return Center(child: Text(state.message));
              } else if (state is AddressLoaded) {
                final addresses = state.addresses;
                TextEditingController _addressController =
                    TextEditingController();

                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Choose Your Location',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Let\'s Find Your Address, Click Here And Select Your Locaion !',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(color: AppColors.grey),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 24.0, bottom: 24.0),
                        child: TextField(
                          controller: _addressController,

                          decoration: InputDecoration(
                            fillColor: AppColors.grey300,
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 6,
                            ),

                            prefixIconColor: AppColors.grey,
                            suffixIconColor: AppColors.grey,
                            labelText: 'Location',
                            labelStyle: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                ),

                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.white),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.grey300),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(16.0),
                              ),
                            ),

                            prefix: Icon(Icons.location_on),
                            suffix: BlocBuilder<CheckoutCubit, CheckoutState>(
                              bloc: cubit,

                              buildWhen: (previous, current) =>
                                  current is AddressAdding ||
                                  current is AddressAdded ||
                                  current is AddressError,
                              builder: (context, state) {
                                if (state is AddressAdding) {
                                  return CircularProgressIndicator(
                                    strokeWidth: 1.0,
                                    color: AppColors.purple,
                                  );
                                }
                                return IconButton(
                                  onPressed: () {
                                    if (!_addressController.text.isEmpty) {
                                      cubit.addAddress(
                                        address: _addressController.text,
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Enter The Address'),
                                        ),
                                      );
                                    }
                                  },
                                  icon: Icon(Icons.add),
                                );
                              },
                            ),

                            hintText: 'Write Your Location: City-Country',
                          ),
                        ),
                      ),
                      SizedBox(height: 24),

                      Text(
                        'Select Location',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: addresses.length,
                        itemBuilder: (context, index) {
                          final address = addresses[index];
                          return BlocBuilder<CheckoutCubit, CheckoutState>(
                            bloc: cubit,
                            buildWhen: (previous, current) =>
                                current is AddressChanged ||
                                current is AddressLoaded,

                            builder: (context, state) {
                              if (state is AddressChanged)
                                return addressWidget(
                                  address: address,
                                  selected: address.id == state.addressId,
                                  onTap: () {
                                    cubit.changeAddressChosen(address.id);
                                  },
                                );
                              else if (state is AddressLoaded)
                                return addressWidget(
                                  address: address,
                                  selected: address.isChosen,
                                  onTap: () {
                                    cubit.changeAddressChosen(address.id);
                                  },
                                );

                              return CircularProgressIndicator(
                                strokeWidth: 2.0,
                                color: AppColors.purple,
                              );
                            },
                          );
                        },
                      ),

                      SizedBox(height: 24),

                      BlocConsumer<CheckoutCubit, CheckoutState>(
                        bloc: cubit,

                        listenWhen: (previous, current) =>
                            current is AddressChoosen,

                        listener: (BuildContext context, CheckoutState state) {
                          Navigator.of(context).pop();
                        },

                        buildWhen: (previous, current) =>
                            current is AddressLoaded ||
                            current is AddressChoosing,

                        builder: (context, state) {
                          if (state is AddressChoosing) {
                            return SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: null,

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.purple,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  color: AppColors.purple,
                                ),
                              ),
                            );
                          }

                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                cubit.confirmAddressChosen();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.purple,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Confirm",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }

              return SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
