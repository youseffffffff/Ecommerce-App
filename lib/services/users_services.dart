import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/address.dart';
import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/models/cart.items.model.dart';
import 'package:ecommerce_app/utils/api_paths.dart';
import 'package:ecommerce_app/utils/paths.dart';
import 'package:flutter/material.dart';

class UserService {
  final CollectionReference usersCollection = FirebaseFirestore.instance
      .collection(ApiPaths.users());

  // Create user
  Future<void> createUser(UserData user) async {
    await usersCollection.doc(user.id).set(user.toMap());
  }

  // Read user by id
  Future<UserData?> getUserById(String id) async {
    final doc = await usersCollection.doc(id).get();
    if (doc.exists) {
      return UserData.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Update user
  Future<void> updateUser(UserData user) async {
    await usersCollection.doc(user.id).update(user.toMap());
  }

  // Delete user
  Future<void> deleteUser(String id) async {
    await usersCollection.doc(id).delete();
  }

  // Get all users
  Future<List<UserData>> getAllUsers() async {
    final querySnapshot = await usersCollection.get();
    return querySnapshot.docs
        .map((doc) => UserData.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
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

      // إذا كان العنصر موجودًا بالفعل، قم بزيادة الكمية
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + item.quantity,
      );
      await usersCollection
          .doc(userId)
          .collection(ApiPaths.cartForUser())
          .doc(item.product.id)
          .set(updatedItem.toMap());
    } else {
      // إذا لم يكن العنصر موجودًا، قم بإضافته كعنصر جديد
      await usersCollection
          .doc(userId)
          .collection(ApiPaths.cartForUser())
          .doc(item.product.id)
          .set(item.toMap());
    }
  }

  // جلب جميع عناصر السلة للمستخدم
  Future<List<CartItem>> getCartItems(String userId) async {
    final querySnapshot = await usersCollection
        .doc(userId)
        .collection(ApiPaths.cartForUser())
        .get();
    return querySnapshot.docs
        .map((doc) => CartItem.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteItemCart(String userId, String productId) async {
    await usersCollection
        .doc(userId)
        .collection(ApiPaths.cartForUser())
        .doc(productId)
        .delete();
  }

  // جلب عنصر واحد من السلة حسب productId
  Future<CartItem?> getCartItemByProductId(
    String userId,
    String productId,
  ) async {
    final doc = await usersCollection
        .doc(userId)
        .collection(ApiPaths.cartForUser())
        .doc(productId)
        .get();
    if (doc.exists) {
      return CartItem.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> addNewAddress(String userId, Address address) async {
    await usersCollection
        .doc(userId)
        .collection(ApiPaths.addressesForUser())
        .doc(address.id)
        .set({
          'id': address.id,
          'city': address.city,
          'country': address.country,
          'imgUrl': address.imgUrl,
          'isChosen': address.isChosen,
        });
  }

  Future<void> deleteAddress(String userId, String addressId) async {
    await usersCollection
        .doc(userId)
        .collection(ApiPaths.addressesForUser())
        .doc(addressId)
        .delete();
  }

  Future<List<Address>> getAllAddresses(String userId) async {
    final querySnapshot = await usersCollection
        .doc(userId)
        .collection(ApiPaths.addressesForUser())
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Address.fromMap(data);
    }).toList();
  }
}
