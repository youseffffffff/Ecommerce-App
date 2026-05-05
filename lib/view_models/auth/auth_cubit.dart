import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/services/auth_services.dart';
import 'package:ecommerce_app/services/firestore_services.dart';
import 'package:ecommerce_app/utils/api_paths.dart';
import 'package:ecommerce_app/utils/current_user.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthServicesImpl _authServices = AuthServicesImpl();

  final firestore = FirestoreService.instance;

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      // Simulate a login process
      final result = await _authServices.signInWithUserNameAndPassword(
        email,
        password,
      );

      if (result) {
        firestore
            .getDocument(ApiPaths.users(), _authServices.currentUser()!.uid)
            .then((doc) {
              if (doc != null && doc.exists) {
                final userData = UserData.fromMap(
                  doc.data() as Map<String, dynamic>,
                );
                currentUser = userData;
                emit(AuthSuccess(user: userData));
              } else {
                emit(AuthFailure("User data not found."));
              }
            })
            .catchError((error) {
              emit(AuthFailure("Failed to fetch user data: $error"));
            });
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
    required String userName,
  }) async {
    emit(AuthLoading());
    try {
      // Simulate a registration process
      final result = await _authServices.registerWithUserNameAndPassword(
        email,
        password,
      );

      if (result) {
        final user = await storeUserData(email: email, userName: userName);
        emit(AuthSuccess(user: user));
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

  Future<UserData> storeUserData({
    required String email,
    required String userName,
  }) async {
    final currentUser = _authServices.currentUser();

    final user = UserData(
      id: currentUser!.uid,
      email: email,
      userName: userName,
      createdAt: DateTime.now(),

      // You should not store passwords in plain text in a real app
    );

    await firestore.setDocument(
      data: user.toMap(),
      collection: ApiPaths.users(),
      docId: user.id,
    );
    return user;
  }

  checkAuth() {
    final user = _authServices.currentUser();

    if (user != null) {
      firestore
          .getDocument(ApiPaths.user(userId: user.uid), user.uid)
          .then((doc) {
            if (doc != null && doc.exists) {
              final userData = UserData.fromMap(
                doc.data() as Map<String, dynamic>,
              );
              currentUser = userData;
              emit(AuthSuccess(user: userData));
            } else {
              emit(AuthInitial());
            }
          })
          .catchError((error) {
            emit(AuthFailure("Failed to fetch user data: $error"));
          });
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

  Future<void> signInWithGoogle() async {
    emit(gAuthLoading());
    try {
      final result = await _authServices.authenticateWithGoogle();

      if (result) {
        UserData user = UserData(
          id: _authServices.currentUser()!.uid,
          email: _authServices.currentUser()!.email ?? '',
          userName: _authServices.currentUser()!.displayName ?? '',
          createdAt: DateTime.now(),
        );
        await firestore.setDocument(
          data: user.toMap(),
          collection: ApiPaths.users(),
          docId: user.id,
        );

        emit(gAuthSuccess(user));
      } else {
        emit(gAuthFailure("Google Sign-In failed. Please try again."));
      }
    } catch (e) {
      emit(gAuthFailure(e.toString()));
    }
  }
}
