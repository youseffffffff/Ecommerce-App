import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/models/product_items_model.dart';
import 'package:meta/meta.dart';

part 'Home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void getHomeContent() {
    emit(HomeLoading());

    try {
      // Simulate loading products
      Future.delayed(Duration(seconds: 1), () {
        emit(HomeLoaded(products: products));
      });
    } catch (e) {
      emit(HomeError());
    }
  }
}
