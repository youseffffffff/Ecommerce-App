class FirestorePaths {
  static String userCart(String userId) => 'users/$userId/itemsCart';
  static String userCartItem(String userId, String productId) =>
      'users/$userId/itemsCart/$productId';
}
