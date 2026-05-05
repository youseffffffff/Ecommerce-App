import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  const FirestoreService._();

  static final instance = FirestoreService._();
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  /// Add or update a document in a collection
  /// If [docId] is null or empty, a new document is added and its reference is returned.
  /// If [docId] is provided, the document is updated (created if not exists) and its reference is returned.
  Future<DocumentReference> setDocument({
    required String collection,
    required Map<String, dynamic> data,
    String? docId,
  }) async {
    final colRef = firestore.collection(collection);
    if (docId == null || docId.isEmpty) {
      return await colRef.add(data);
    } else {
      final docRef = colRef.doc(docId);
      await docRef.set(data, SetOptions(merge: true));
      return docRef;
    }
  }

  // Get a document by ID
  Future<DocumentSnapshot?> getDocument(String collection, String docId) async {
    return await firestore.collection(collection).doc(docId).get();
  }

  // Delete a document
  Future<void> deleteDocument(String collection, String docId) async {
    await firestore.collection(collection).doc(docId).delete();
  }

  // Get all documents in a collection
  Stream<QuerySnapshot> getCollectionStream(String collection) {
    try {
      var result = firestore.collection(collection).snapshots();
      return result;
    } catch (e) {
      rethrow;
    }
  }

  // Get documents with a query
  Stream<QuerySnapshot> getDocumentsWithQuery(
    String collection,
    String field,
    dynamic value,
  ) {
    return firestore
        .collection(collection)
        .where(field, isEqualTo: value)
        .snapshots();
  }
}
