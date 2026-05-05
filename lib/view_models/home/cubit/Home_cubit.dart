import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/models/product_items_model.dart';
import 'package:ecommerce_app/services/preducts.dart';
import 'package:meta/meta.dart';

part 'Home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ProductService _productService;

  HomeCubit({ProductService? productService})
    : _productService = productService ?? ProductService(),
      super(HomeInitial());

  void getHomeContent() {
    emit(HomeLoading());
    _productService.getProductsStream().listen(
      (productList) {
        emit(HomeLoaded(products: productList));
      },
      onError: (e) {
        emit(HomeError(message: e.toString()));
      },
    );
  }
}
