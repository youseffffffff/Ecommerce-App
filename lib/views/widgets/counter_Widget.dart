import 'package:ecommerce_app/models/product_items_model.dart';
import 'package:ecommerce_app/view_models/cart/cubit/cart_cubit.dart';
import 'package:ecommerce_app/view_models/product/cubit/product_cubit.dart';
import 'package:flutter/material.dart';

class CounterWidget extends StatefulWidget {
  final int quantity;
  final ProductSize size;

  final String productId;
  final String userId;
  final VoidCallback actionIfIncrement;
  final VoidCallback actionIfDecrement;

  CounterWidget({
    super.key,
    required this.quantity,
    required this.size,
    required this.actionIfIncrement,
    required this.actionIfDecrement,
    required this.productId,
    required this.userId,
  });

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.05,
      width: size.width * 0.3,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: widget.actionIfIncrement,
            icon: Icon(Icons.add),
          ),

          Text(widget.quantity.toString()),

          IconButton(
            onPressed: widget.actionIfDecrement,
            icon: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
