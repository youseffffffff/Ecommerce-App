part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final UserData user;

  AuthSuccess({required this.user});
}

final class AuthFailure extends AuthState {
  final String errorMessage;

  AuthFailure(this.errorMessage);
}

final class AuthLoggedOut extends AuthState {}

final class gAuthLoading extends AuthState {}

final class gAuthSuccess extends AuthState {
  final UserData result;

  gAuthSuccess(this.result);
}

final class gAuthFailure extends AuthState {
  final String errorMessage;

  gAuthFailure(this.errorMessage);
}

final class gAuthLoggedOut extends AuthState {}
