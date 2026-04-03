part of 'user_cubit.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class UsersLoading extends UserState {}

final class UsersLoaded extends UserState {
  final List<UserData> users;

  UsersLoaded({required this.users});
}

final class UsersLoadField extends UserState {
  final String message;

  UsersLoadField({this.message = "An error occurred while loading products."});
}

final class UserAdding extends UserState {}

final class UserAdded extends UserState {
  final List<UserData> users;

  UserAdded({required this.users});
}

final class UserAddField extends UserState {
  final String message;

  UserAddField({this.message = "An error occurred while loading products."});
}

final class UserSearching extends UserState {}

final class UserSearched extends UserState {
  final UserData user;

  UserSearched({required this.user});
}

final class UserSearchField extends UserState {
  final String message;

  UserSearchField({this.message = "An error occurred while loading products."});
}

final class UserSearchNotFound extends UserState {
  final String message;

  UserSearchNotFound({this.message = "Incurrect Password Or Email."});
}
