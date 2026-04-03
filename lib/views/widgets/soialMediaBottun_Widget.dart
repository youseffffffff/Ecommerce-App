import 'package:ecommerce_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class SoialMediaBottun extends StatefulWidget {
  final title;
  final icon;
  final event;

  const SoialMediaBottun({super.key, this.title, this.icon, this.event});

  @override
  State<SoialMediaBottun> createState() => _SoialMediaBottunState();
}

class _SoialMediaBottunState extends State<SoialMediaBottun> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.event,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(16),
        ),

        child: ListTile(leading: widget.icon, title: Text(widget.title)),
      ),
    );
  }
}
