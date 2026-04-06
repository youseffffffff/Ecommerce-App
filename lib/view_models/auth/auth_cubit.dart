import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/services/auth_services.dart';
import 'package:ecommerce_app/utils/current_user.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthServicesImpl _authServices = AuthServicesImpl();

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      // Simulate a login process
      final result = await _authServices.signInWithUserNameAndPassword(
        email,
        password,
      );

      if (result) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure("Login failed. Please check your credentials."));
      }
      // For demonstration, we assume the login is always successful
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      // Simulate a registration process
      final result = await _authServices.registerWithUserNameAndPassword(
        email,
        password,
      );

      if (result) {
        emit(AuthSuccess());
      } else {
        emit(
          AuthFailure("Registration failed. Please check your credentials."),
        );
      }
      // For demonstration, we assume the registration is always successful
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  checkAuth() {
    final user = _authServices.currentUser();

    if (user != null) {
      currentUser = users[0];
      emit(AuthSuccess());
    } else {
      emit(AuthInitial());
    }
  }

  Future<void> logout() async {
    try {
      emit(AuthLoading());

      await _authServices.logout();

      currentUser = null;

      emit(AuthLoggedOut());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
