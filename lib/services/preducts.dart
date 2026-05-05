import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_items_model.dart';
import 'firestore_services.dart';
import '../utils/api_paths.dart';

class ProductService {
  static String get _collection => ApiPaths.products();

  // Create or update product
  Future<DocumentReference> upsertProduct(Product product) async {
    return await FirestoreService.instance.setDocument(
      collection: _collection,
      data: product.toMap(),
      docId: product.id.toString(),
    );
  }

  // Read product by id
  Future<Product?> getProductById(String id) async {
    final doc = await FirestoreService.instance.getDocument(_collection, id);
    if (doc != null && doc.exists) {
      return Product.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Delete product
  Future<void> deleteProduct(String id) async {
    await FirestoreService.instance.deleteDocument(_collection, id);
  }

  // Get all products as stream
  Stream<List<Product>> getProductsStream() {
    return FirestoreService.instance
        .getCollectionStream(_collection)
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  // Mapping logic moved to Product model
}
