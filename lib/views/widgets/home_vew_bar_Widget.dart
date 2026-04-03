import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/models/casousel_image_items.model.dart';
import 'package:ecommerce_app/models/product_items_model.dart';
import 'package:ecommerce_app/utils/App_Routes.dart';
import 'package:ecommerce_app/utils/app_colors.dart';

import 'package:ecommerce_app/views/widgets/productItem_Widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class HomeViewBar extends StatefulWidget {
  final List<Product> products;
  const HomeViewBar({super.key, required this.products});

  @override
  State<HomeViewBar> createState() => _HomeViewBarState();
}

class _HomeViewBarState extends State<HomeViewBar> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 15),

          FlutterCarousel.builder(
            options: FlutterCarouselOptions(
              height: 150,
              autoPlay: true,
              slideIndicator: CircularWaveSlideIndicator(),

              autoPlayInterval: Duration(seconds: 3),
              enlargeCenterPage: true,
            ),

            itemCount: carouselItems.length,
            itemBuilder: (context, index, realIndex) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: carouselItems[index].imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 150,

                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),

                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: Icon(Icons.error, color: Colors.red),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'New Arrivals',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              Text(
                'See All',
                style: TextStyle(fontSize: 12, color: AppColors.grey),
              ),
            ],
          ),

          SizedBox(height: 10),

          GridView.builder(
            itemCount: this.widget.products.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context, rootNavigator: true)
                      .pushNamed(
                        AppRoutes.productDetails,
                        arguments: this.widget.products[index].id,
                      )
                      .then((value) => setState(() {}));
                },
                child: ProductItem(product: this.widget.products[index]),
              );
            },

            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
          ),
        ],
      ),
    );
  }
}
