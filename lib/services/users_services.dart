import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/order.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:ecommerce_app/models/address.dart';
import 'package:ecommerce_app/services/users_services.dart';
import 'package:ecommerce_app/models/paymentMethod.model.dart';
import 'package:ecommerce_app/models/product_items_model.dart';
import 'package:ecommerce_app/services/preducts.dart';
import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/models/cart.items.model.dart';
import 'package:ecommerce_app/utils/api_paths.dart';
import 'package:ecommerce_app/utils/paths.dart';
import 'package:flutter/material.dart';

class UserService {
  final ProductService _productService = ProductService();
  final FirestoreService _firestoreService = FirestoreService.instance;

  // Add a new favorite for the user
  Future<void> addNewFavorite(String userId, String productId) async {
    await _firestoreService.setDocument(
      collection:
          '${ApiPaths.users()}/$userId/${ApiPaths.favoriteProductsForUser()}',
      data: {'productId': productId},
      docId: productId,
    );
  }

  // Delete a favorite for the user
  Future<void> deleteFavorite(String userId, String productId) async {
    await _firestoreService.deleteDocument(
      '${ApiPaths.users()}/$userId/${ApiPaths.favoriteProductsForUser()}',
      productId,
    );
  }

  Future<List<Product>> getAllFavorites(String userId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection(ApiPaths.users())
        .doc(userId)
        .collection(ApiPaths.favoriteProductsForUser())
        .get();

    return Future.wait(
      querySnapshot.docs.map((doc) async {
        final product = await _productService.getProductById(doc['productId']);
        return product!;
      }).toList(),
    );
  }

  ///////////////////////

  // Add a new card for the user
  Future<void> addNewCard(String userId, PaymentMethod card) async {
    await _firestoreService.setDocument(
      collection: '${ApiPaths.users()}/$userId/${ApiPaths.cardsForUser()}',
      data: card.toMap(),
      docId: card.Id,
    );
  }

  // Delete a card for the user
  Future<void> deleteCard(String userId, String cardId) async {
    await _firestoreService.deleteDocument(
      '${ApiPaths.users()}/$userId/${ApiPaths.cardsForUser()}',
      cardId,
    );
  }

  Future<void> clearCart(String userId) async {
    final cartCollection = FirebaseFirestore.instance
        .collection(ApiPaths.users())
        .doc(userId)
        .collection(ApiPaths.cartForUser());

    final querySnapshot = await cartCollection.get();
    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<List<PaymentMethod>> getAllCards(String userId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection(ApiPaths.users())
        .doc(userId)
        .collection(ApiPaths.cardsForUser())
        .get();

    return querySnapshot.docs.map((doc) {
      return PaymentMethod.fromMap(doc.data());
    }).toList();
  }

  // Create user
  Future<void> createUser(UserData user) async {
    await _firestoreService.setDocument(
      collection: ApiPaths.users(),
      data: user.toMap(),
      docId: user.id,
    );
  }

  // Read user by id
  Future<UserData?> getUserById(String id) async {
    final doc = await _firestoreService.getDocument(ApiPaths.users(), id);
    if (doc != null && doc.exists) {
      return UserData.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Update user
  Future<void> updateUser(UserData user) async {
    await _firestoreService.setDocument(
      collection: ApiPaths.users(),
      data: user.toMap(),
      docId: user.id,
    );
  }

  // Delete user
  Future<void> deleteUser(String id) async {
    await _firestoreService.deleteDocument(ApiPaths.users(), id);
  }

  // Get all orders
  Future<List<UserOrder>> getAllOrders() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection(ApiPaths.ordersForUser())
        .get();
    return querySnapshot.docs
        .map((doc) => UserOrder.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> addNewOrder(UserOrder order) async {
    await _firestoreService.setDocument(
      collection: ApiPaths.ordersForUser(),
      data: order.toMap(),
      docId: order.id,
    );
  }

  // جلب جميع عناصر السلة للمستخدم
  Future<List<CartItem>> getCartItems(String userId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection(ApiPaths.users())
        .doc(userId)
        .collection(ApiPaths.cartForUser())
        .get();
    return Future.wait(
      querySnapshot.docs.map((doc) async {
        return await CartItem.fromMap(doc.data() as Map<String, dynamic>);
      }).toList(),
    );
  }

  Future<void> deleteItemCart(String userId, String productId) async {
    await _firestoreService.deleteDocument(
      '${ApiPaths.user(userId: userId)}/${ApiPaths.cartForUser()}',
      productId,
    );
  }

  // إضافة عنصر للسلة
  Future<void> addCartItem(String userId, CartItem item) async {
    CartItem? existingItem = await getCartItemByProductId(
      userId,
      item.product.id,
    );
    if (existingItem != null) {
      if ((existingItem.quantity + item.quantity) < 1) {
        await deleteItemCart(userId, item.product.id);
        return;
      }

      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + item.quantity,
      );

      await _firestoreService.setDocument(
        collection:
            '${ApiPaths.user(userId: userId)}/${ApiPaths.cartForUser()}',
        data: updatedItem.toMap(),
        docId: item.product.id,
      );
    } else {
      await _firestoreService.setDocument(
        collection:
            '${ApiPaths.user(userId: userId)}/${ApiPaths.cartForUser()}',
        data: item.toMap(),
        docId: item.product.id,
      );
    }
  }

  Future<CartItem?> getCartItemByProductId(
    String userId,
    String productId,
  ) async {
    final doc = await _firestoreService.getDocument(
      '${ApiPaths.user(userId: userId)}/${ApiPaths.cartForUser()}',
      productId,
    );
    if (doc != null && doc.exists) {
      return CartItem.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> addNewAddress(String userId, Address address) async {
    await _firestoreService.setDocument(
      collection: '${ApiPaths.users()}/$userId/${ApiPaths.addressesForUser()}',
      data: address.toMap(),
      docId: address.id,
    );
  }

  Future<void> deleteAddress(String userId, String addressId) async {
    await _firestoreService.deleteDocument(
      '${ApiPaths.users()}/$userId/${ApiPaths.addressesForUser()}',
      addressId,
    );
  }

  Future<List<Address>> getAllAddresses(String userId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection(ApiPaths.users())
        .doc(userId)
        .collection(ApiPaths.addressesForUser())
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Address.fromMap(data);
    }).toList();
  }

  //   Future<void> addNewOrder(String userId, Order order) async {

  //     await _firestoreService.setDocument(
  //       collection: '${ApiPaths.users()}/$userId/${ApiPaths.ordersForUser()}',
  //       data: order.toMap(),
  //       docId: order.id,
  //     );

  // }
}
