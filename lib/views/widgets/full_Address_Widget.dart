import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/models/address.dart';
import 'package:ecommerce_app/models/paymentMethod.model.dart';
import 'package:ecommerce_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class adButton_Full extends StatelessWidget {
  final VoidCallback onClick;
  final Address address;
  final Color bgColor;
  final Widget trealing;

  adButton_Full({
    super.key,
    required this.onClick,
    required this.address,
    this.bgColor = AppColors.grey,
    required this.trealing,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: onClick,
      child: Container(
        width: double.infinity,

        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: address.imgUrl,
              height: size.height * 0.09,
              width: size.width * 0.2,

              errorWidget: (context, error, stackTrace) {
                return Container(
                  color: AppColors.grey100,
                  child: const Icon(Icons.image_not_supported),
                );
              },
            ),
          ),
          title: Text(
            address.city,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            address.country,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          trailing: trealing,
        ),
      ),
    );
  }
}
