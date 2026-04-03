import 'package:ecommerce_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class button_Empty extends StatelessWidget {
  final VoidCallback onClick;
  final String title;
  const button_Empty({super.key, required this.onClick, required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            const Icon(Icons.add, size: 32, color: AppColors.grey),
            const SizedBox(height: 8),
            Text(
              title,
              //"Add Payment Method",
              style: TextStyle(color: AppColors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
