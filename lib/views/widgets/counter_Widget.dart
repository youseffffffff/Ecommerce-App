import 'package:ecommerce_app/models/product_items_model.dart';
import 'package:flutter/material.dart';

class CounterWidget extends StatefulWidget {
  final int quantity;
  final ProductSize size;

  dynamic cupit;
  final int productId;
  CounterWidget({
    super.key,
    required this.quantity,
    required this.size,
    required this.cupit,
    required this.productId,
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
            onPressed: () =>
                widget.cupit.incrementQuantity(widget.productId, widget.size),
            icon: Icon(Icons.add),
          ),

          Text(widget.quantity.toString()),

          IconButton(
            onPressed: () =>
                widget.cupit.decrementQuantity(widget.productId, widget.size),
            icon: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
