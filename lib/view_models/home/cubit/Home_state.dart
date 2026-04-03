part of 'Home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoaded extends HomeState {
  final List<Product> products;

  HomeLoaded({required this.products});
}

final class HomeError extends HomeState {
  final String message;

  HomeError({this.message = "An error occurred while loading products."});
}

final class HomeLoading extends HomeState {}
