import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/models/product_items_model.dart';
import 'package:ecommerce_app/utils/app_colors.dart';
import 'package:ecommerce_app/view_models/checkout/cubit/checkout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductItem extends StatefulWidget {
  Product product;

  ProductItem({super.key, required this.product});

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<CheckoutCubit>(context).loadCheckout();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),

          child: Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,

            child: Stack(
              children: [
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: widget.product.imageUrl,
                        height: constraints.maxHeight * 0.7,
                        width: constraints.maxWidth,
                        fit: BoxFit.cover,

                        errorWidget: (context, url, error) => Container(
                          height: constraints.maxHeight * 0.7,
                          width: constraints.maxWidth,
                          color: AppColors.grey,
                          child: Center(
                            child: Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                        placeholder: (context, url) => Container(
                          height: constraints.maxHeight * 0.7,
                          width: constraints.maxWidth,
                          color: AppColors.grey,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),

                      // Image.network(
                      //   widget.product.imageUrl,
                      //   height: constraints.maxHeight * 0.7,
                      //   width: constraints.maxWidth,
                      //   fit: BoxFit.cover,
                      // ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.product.name,
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(
                                fontSize: constraints.maxHeight * 0.08,

                                fontWeight: FontWeight.bold,
                              ),
                        ),

                        Text(
                          '\$${widget.product.category}',
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                color: AppColors.black.withOpacity(0.5),
                                fontSize: constraints.maxHeight * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                        ),

                        Text(
                          '\$${widget.product.price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                fontSize: constraints.maxHeight * 0.055,

                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),

                Positioned(
                  top: 2,
                  right: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),

                    child: Center(
                      child: Container(
                        height: constraints.maxHeight * 0.145,
                        width: constraints.maxWidth * 0.145,
                        color: AppColors.black.withOpacity(0.4),
                        child: IconButton(
                          icon: Icon(
                            widget.product.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: AppColors.white,
                            size: constraints.maxHeight * 0.07,
                          ),
                          onPressed: () {
                            setState(() {
                              widget.product = widget.product.copyWith(
                                isFavorite: !widget.product.isFavorite,
                              );
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
