import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/models/category_items_model.dart';
import 'package:ecommerce_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CategoryViewBar extends StatelessWidget {
  const CategoryViewBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        Size size = MediaQuery.of(context).size;

        CategoryModel model = categories[index];
        ClipRRect img = ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CachedNetworkImage(
            imageUrl: model.ImageUrl,
            height: size.height * 0.2,
            width: size.width * 0.3,
            fit: BoxFit.cover,

            errorWidget: (context, url, error) => Container(
              height: size.height * 0.7,
              width: size.width * 0.3,
              color: AppColors.grey,
              child: Center(child: Icon(Icons.error, color: Colors.red)),
            ),
            placeholder: (context, url) => Container(
              height: size.height * 0.7,
              width: size.width * 0.3,
              color: AppColors.grey,
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
        );

        Column col = Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text(
              model.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: model.textColor,
              ),
            ),

            Text(
              '\$${model.productCount} Products',
              style: TextStyle(
                fontSize: 12,
                color: model.textColor.withOpacity(0.7),
              ),
            ),
          ],
        );

        return Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: model.bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,

              children: [
                // Container(
                //   height: 110,
                //   width: 110,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(10),
                //     image: DecorationImage(
                //       image: NetworkImage(model.ImageUrl),
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // ),
                if (index % 2 == 0) ...[
                  img,
                  SizedBox(width: 10),
                  col,
                ] else ...[
                  col,
                  SizedBox(width: 10),
                  img,
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

// Icon(Icons.arrow_forward_ios)

//Icon(Icons.category)
