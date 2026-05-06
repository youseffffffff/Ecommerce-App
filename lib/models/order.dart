import 'package:ecommerce_app/models/cart.items.model.dart';

class UserOrder {
  final String id;
  final String userId;
  final List<CartItem> items;

  UserOrder({required this.id, required this.userId, required this.items});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  factory UserOrder.fromMap(Map<String, dynamic> map) {
    return UserOrder(
      id: map['id'],
      userId: map['userId'],
      items: List<CartItem>.from(
        (map['items'] as List).map((item) => CartItem.fromMap(item)),
      ),
    );
  }
}
