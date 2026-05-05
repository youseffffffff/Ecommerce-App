import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/models/cart.items.model.dart';
import 'package:ecommerce_app/utils/App_Routes.dart';
import 'package:ecommerce_app/utils/app_colors.dart';
import 'package:ecommerce_app/utils/current_user.dart';
import 'package:ecommerce_app/view_models/cart/cubit/cart_cubit.dart';
import 'package:ecommerce_app/views/widgets/counter_Widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cubit = BlocProvider.of<CartCubit>(context);

    return BlocBuilder<CartCubit, CartState>(
      bloc: cubit,

      buildWhen: (previous, current) =>
          current is CartLoaded ||
          current is CartError ||
          current is CartLoading,

      builder: (context, state) {
        if (state is CartLoading) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (state is CartLoaded) {
          if (state.items.isEmpty) {
            return Scaffold(body: Center(child: Text('Your cart is empty')));
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Your Cart',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),

            body: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,

                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      // TODO: اجلب userId الصحيح من مزود المستخدم أو AuthCubit
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: item.product.imageUrl,
                                height: size.height * 0.14,
                                width: size.width * 0.3,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) => Container(
                                  height: size.height * 0.1,
                                  width: size.width * 0.2,
                                  color: AppColors.grey,
                                  child: Center(
                                    child: Icon(Icons.error, color: Colors.red),
                                  ),
                                ),
                                placeholder: (context, url) => Container(
                                  height: size.height * 0.1,
                                  width: size.width * 0.2,
                                  color: AppColors.grey,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: size.width * 0.03),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.product.name),
                                  Text.rich(
                                    TextSpan(
                                      text: 'Size: ',
                                      style: TextStyle(color: Colors.grey),
                                      children: [
                                        TextSpan(
                                          text: item.size.name.toUpperCase(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.03),
                                  BlocBuilder<CartCubit, CartState>(
                                    buildWhen: (previous, current) =>
                                        current is QuantityLoaded &&
                                            current.cart.product.id ==
                                                item.product.id &&
                                            current.cart.size == item.size ||
                                        current is CartLoaded,
                                    builder: (context, state) {
                                      if (state is QuantityLoaded &&
                                          state.cart.product.id ==
                                              item.product.id &&
                                          state.cart.size == item.size) {
                                        return SizedBox(
                                          width: size.width * 0.28,
                                          child: CounterWidget(
                                            quantity: state.quantity,
                                            productId: state.cart.product.id,
                                            size: state.cart.size,
                                            userId: currentUser!.id,
                                            actionIfIncrement: () async {
                                              await cubit.incrementQuantity(
                                                currentUser!.id,
                                                item.product.id,
                                                item.size,
                                              );
                                            },
                                            actionIfDecrement: () async {
                                              await cubit.decrementQuantity(
                                                currentUser!.id,
                                                item.product.id,
                                                item.size,
                                              );
                                            },
                                          ),
                                        );
                                      } else {
                                        return SizedBox(
                                          width:
                                              size.width *
                                              0.28, // أو الحجم المناسب حسب التصميم
                                          child: CounterWidget(
                                            quantity: item.quantity,
                                            actionIfIncrement: () async {
                                              await cubit.incrementQuantity(
                                                currentUser!.id,
                                                item.product.id,
                                                item.size,
                                              );
                                            },
                                            actionIfDecrement: () async {
                                              await cubit.decrementQuantity(
                                                currentUser!.id,
                                                item.product.id,
                                                item.size,
                                              );
                                            },
                                            productId: item.product.id,
                                            size: item.size,
                                            userId: currentUser!.id,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            //Spacer(),
                            BlocBuilder<CartCubit, CartState>(
                              buildWhen: (previous, current) =>
                                  current is QuantityLoaded &&
                                      current.cart.product.id ==
                                          item.product.id &&
                                      current.cart.size == item.size ||
                                  current is CartLoaded,
                              builder: (context, state) {
                                if (state is QuantityLoaded &&
                                    state.cart.product.id == item.product.id &&
                                    state.cart.size == item.size) {
                                  return Text(
                                    "${(state.quantity * item.product.price).toStringAsFixed(2)} \$",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  );
                                } else {
                                  return Text(
                                    "${(item.quantity * item.product.price).toStringAsFixed(2)} \$",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },

                    separatorBuilder: (context, index) => Divider(height: 10),
                  ),

                  SizedBox(height: size.height * 0.03),
                  BlocBuilder<CartCubit, CartState>(
                    bloc: cubit,
                    buildWhen: (previous, current) =>
                        current is CartLoaded || current is QuantityLoaded,
                    builder: (context, state) {
                      if (state is QuantityLoaded) {
                        double subtotal = state.items.fold(
                          0.0,
                          (total, item) =>
                              total + item.quantity * item.product.price,
                        );

                        return Column(
                          children: [
                            details('Subtotal', subtotal.toStringAsFixed(2)),
                            SizedBox(height: size.height * 0.01),
                            Dash(
                              direction: Axis.horizontal,
                              length: size.width * 0.9,
                              dashLength: 10,
                              dashColor: AppColors.grey,
                            ),
                            SizedBox(height: size.height * 0.01),
                            details('Delivery Fee', 10.00.toStringAsFixed(2)),
                            SizedBox(height: size.height * 0.01),
                            Dash(
                              direction: Axis.horizontal,
                              length: size.width * 0.9,
                              dashLength: 10,
                              dashColor: AppColors.grey,
                            ),
                            SizedBox(height: size.height * 0.01),
                            details(
                              "Total amount",
                              (subtotal + 10).toStringAsFixed(2),
                            ),
                            SizedBox(height: size.height * 0.05),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pushNamed(
                                  AppRoutes.checkout,
                                  arguments: state.items,
                                );
                              },
                              child: Text(
                                'Checkout',
                                style: Theme.of(context).textTheme.titleMedium!
                                    .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.purple,

                                padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.4,
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      if (state is CartLoaded) {
                        double subtotal = state.items.fold(
                          0.0,
                          (total, item) =>
                              total + item.quantity * item.product.price,
                        );

                        return Column(
                          children: [
                            details('Subtotal', subtotal.toStringAsFixed(2)),
                            SizedBox(height: size.height * 0.01),
                            Dash(
                              direction: Axis.horizontal,
                              length: size.width * 0.9,
                              dashLength: 10,
                              dashColor: AppColors.grey,
                            ),
                            SizedBox(height: size.height * 0.01),
                            details('Delivery Fee', 10.00.toStringAsFixed(2)),
                            SizedBox(height: size.height * 0.01),
                            Dash(
                              direction: Axis.horizontal,
                              length: size.width * 0.9,
                              dashLength: 10,
                              dashColor: AppColors.grey,
                            ),
                            SizedBox(height: size.height * 0.01),
                            details(
                              "Total amount",
                              (subtotal + 10).toStringAsFixed(2),
                            ),
                            SizedBox(height: size.height * 0.05),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pushNamed(AppRoutes.checkout);
                              },

                              child: Text(
                                'Checkout',
                                style: Theme.of(context).textTheme.titleMedium!
                                    .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.purple,

                                padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.4,
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        } else if (state is CartError) {
          return Scaffold(body: Center(child: Text(state.message)));
        } else {
          return Scaffold(body: Center(child: Text('Your cart is empty')));
        }
      },
    );
  }

  Widget details(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.grey,
            ),
          ),
          Text("${value} \$", style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
