class ApiPaths {
  static String user({required String userId}) => 'users/$userId';
  static String users() => 'users';

  static String product({required String productId}) => 'products/$productId';
  static String products() => 'products';

  static String cartForUser() => 'itemsCart';
  static String addressesForUser() => 'addresses';

  static String cardsForUser() => 'usercards';

  static String favoriteProductsForUser() => 'favoriteProducts';
  static String favoriteProductForUser({required String productId}) =>
      'favoriteProducts/$productId';

  static String ordersForUser() => 'orders';
}
