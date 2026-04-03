import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/models/product_items_model.dart';
import 'package:ecommerce_app/utils/app_colors.dart';
import 'package:ecommerce_app/utils/messenger.dart';
import 'package:ecommerce_app/view_models/product/cubit/product_cubit.dart';
import 'package:ecommerce_app/views/widgets/counter_Widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetails extends StatefulWidget {
  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<ProductCubit, ProductState>(
      bloc: context.read<ProductCubit>(),

      buildWhen: (previous, current) =>
          current is ProductLoading ||
          current is ProductLoaded ||
          current is ProductError,

      builder: (context, state) {
        if (state is ProductLoading) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'Product Details',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is ProductError) {
          return Scaffold(
            appBar: AppBar(title: Text('Product Details')),
            body: Center(child: Text('No product details available')),
          );
        } else if (state is ProductLoaded) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text(
                'Product Details',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),

              actions: [
                BlocBuilder<ProductCubit, ProductState>(
                  buildWhen: (previous, current) =>
                      current is ProductFavoriteChanged ||
                      current is ProductLoaded,

                  bloc: BlocProvider.of<ProductCubit>(context),

                  builder: (context, state) {
                    if (state is ProductFavoriteChanged) {
                      return IconButton(
                        icon: Icon(
                          state.product.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: AppColors.black,
                        ),
                        onPressed: () {
                          BlocProvider.of<ProductCubit>(
                            context,
                          ).changeFavoriteStatus(state.product);
                        },
                      );
                    } else if (state is ProductLoaded) {
                      return IconButton(
                        icon: Icon(
                          state.product.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: AppColors.black,
                        ),
                        onPressed: () {
                          BlocProvider.of<ProductCubit>(
                            context,
                          ).changeFavoriteStatus(state.product);
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
            body: Stack(
              children: [
                // Space for the image
                CachedNetworkImage(
                  imageUrl: state.product.imageUrl,

                  errorWidget: (context, url, error) => Container(
                    height: size.height * 0.3,
                    width: size.width * 0.6,

                    child: Center(child: Icon(Icons.error, color: Colors.red)),
                  ),
                  placeholder: (context, url) => Container(
                    height: size.height * 0.3,
                    width: size.width * 0.6,
                    color: AppColors.grey,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.287),
                  child: Container(
                    padding: EdgeInsets.all(30.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.0),
                        topRight: Radius.circular(24.0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.product.name,
                          style: Theme.of(context).textTheme.headlineSmall!
                              .copyWith(
                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: AppColors.yellow,
                              size: size.width * 0.06,
                            ),
                            Text(
                              '${state.product.averageRate}',
                              style: Theme.of(context).textTheme.headlineMedium!
                                  .copyWith(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.width * 0.045,
                                  ),
                            ),
                            Spacer(),

                            BlocBuilder<ProductCubit, ProductState>(
                              bloc: BlocProvider.of<ProductCubit>(context),

                              buildWhen: (previous, current) =>
                                  current is QuantityLoaded ||
                                  current is ProductLoaded,

                              builder: (context, state) {
                                if (state is QuantityLoaded) {
                                  return CounterWidget(
                                    quantity: state.quantity,
                                    cupit: BlocProvider.of<ProductCubit>(
                                      context,
                                    ),
                                    productId: state.product.id,
                                    size: BlocProvider.of<ProductCubit>(
                                      context,
                                    ).selectedSize,
                                  );
                                } else if (state is ProductLoaded) {
                                  return CounterWidget(
                                    quantity: 1,
                                    cupit: BlocProvider.of<ProductCubit>(
                                      context,
                                    ),
                                    productId: state.product.id,
                                    size: BlocProvider.of<ProductCubit>(
                                      context,
                                    ).selectedSize,
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.02),

                        if (state.product.availableSizes != null &&
                            state.product.availableSizes!.isNotEmpty) ...[
                          Text(
                            "Size",
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          SizedBox(height: size.height * 0.001),

                          BlocBuilder<ProductCubit, ProductState>(
                            bloc: BlocProvider.of<ProductCubit>(context),

                            buildWhen: (previous, current) =>
                                current is SizeSelected ||
                                current is ProductLoaded,
                            builder: (context, state) {
                              if (state is ProductLoaded) {
                                return Row(
                                  children: state.product.availableSizes!
                                      .map(
                                        (size) => InkWell(
                                          onTap: () {
                                            BlocProvider.of<ProductCubit>(
                                              context,
                                            ).selectSize(
                                              size,
                                              state.product.id,
                                            );
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 4.0,
                                            ),
                                            padding: EdgeInsets.only(
                                              left: 8.0,
                                              right: 8.0,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: AppColors.grey,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                              color: AppColors.grey100
                                                  .withOpacity(0.8),
                                            ),
                                            child: Text(
                                              size.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    color: AppColors.black,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                );
                              } else if (state is SizeSelected) {
                                return Row(
                                  children: state.product.availableSizes!
                                      .map(
                                        (size) => InkWell(
                                          onTap: () {
                                            BlocProvider.of<ProductCubit>(
                                              context,
                                            ).selectSize(
                                              size,
                                              state.product.id,
                                            );
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 4.0,
                                            ),
                                            padding: EdgeInsets.only(
                                              left: 8.0,
                                              right: 8.0,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color:
                                                    state is SizeSelected &&
                                                        state.productSize ==
                                                            size
                                                    ? AppColors.purple
                                                    : AppColors.grey,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                              color: state.productSize == size
                                                  ? AppColors.purple
                                                  : AppColors.grey100
                                                        .withOpacity(0.8),
                                            ),
                                            child: Text(
                                              size.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    color: AppColors.black,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ],

                        SizedBox(height: size.height * 0.03),

                        Text(
                          "Description",
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(
                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(height: size.height * 0.001),
                        Text(
                          state.product.description,
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(color: AppColors.grey),
                        ),

                        Spacer(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "\$",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(
                                        color: AppColors.purple,
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.width * 0.06,
                                      ),
                                ),

                                Text(
                                  "${state.product.price.toStringAsFixed(2)}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(
                                        color: AppColors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.width * 0.06,
                                      ),
                                ),
                              ],
                            ),

                            BlocBuilder<ProductCubit, ProductState>(
                              bloc: BlocProvider.of<ProductCubit>(context),
                              buildWhen: (previous, current) =>
                                  current is CartIsAdding ||
                                  current is CartIsAdded ||
                                  current is ProductLoaded,
                              builder: (context, state) {
                                if (state is CartIsAdding) {
                                  return ElevatedButton.icon(
                                    onPressed: null,
                                    icon: SizedBox(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        color: AppColors.white,
                                      ),
                                    ),
                                    label: Text(
                                      'Adding...',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: AppColors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.purple,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 24.0,
                                        vertical: 12.0,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          20.0,
                                        ),
                                      ),
                                    ),
                                  );
                                } else if (state is CartIsAdded) {
                                  return ElevatedButton.icon(
                                    onPressed: null,
                                    icon: Icon(
                                      Icons.check,
                                      color: AppColors.white,
                                    ),
                                    label: Text(
                                      'Added',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: AppColors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.purple,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 24.0,
                                        vertical: 12.0,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          20.0,
                                        ),
                                      ),
                                    ),
                                  );
                                } else if (state is ProductLoaded) {
                                  return ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.purple,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 24.0,
                                        vertical: 12.0,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          20.0,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (state.product.availableSizes !=
                                              null &&
                                          state
                                              .product
                                              .availableSizes!
                                              .isNotEmpty &&
                                          BlocProvider.of<ProductCubit>(
                                                context,
                                              ).selectedSize ==
                                              ProductSize.none) {
                                        Messenger.showMessage(
                                          context,
                                          "Please select a size before adding to cart.",
                                        );
                                      } else {
                                        BlocProvider.of<ProductCubit>(
                                          context,
                                        ).addToCart(state.product);
                                      }
                                    },
                                    icon: Icon(
                                      Icons.shopping_cart_outlined,
                                      color: AppColors.white,
                                    ),
                                    label: Text(
                                      'Add to Cart',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: AppColors.white),
                                    ),
                                  );
                                }

                                return ElevatedButton.icon(
                                  onPressed: null,

                                  icon: Icon(
                                    Icons.shopping_cart_outlined,
                                    color: AppColors.white,
                                  ),
                                  label: Text(
                                    'Add to Cart',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: AppColors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.purple,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24.0,
                                      vertical: 12.0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(title: Text('Product Details')),
            body: Center(child: Text('No product details available')),
          );
        }
      },
    );
  }
}
