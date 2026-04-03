import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/models/user.dart';
import 'package:meta/meta.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  void findUser({required String email, required String password}) {
    emit(UserSearching());

    Future.delayed(Duration(seconds: 1), () {
      final userIndex = users.indexWhere(
        (user) => user.email == email && user.password == password,
      );
      if (userIndex != -1) {
        emit(UserSearched(user: users[userIndex]));
      } else {
        emit(UserSearchNotFound());
      }
    });
  }

  void addUser({required UserData user}) {
    emit(UserAdding());

    Future.delayed(Duration(seconds: 1), () {
      users.add(
        UserData(
          id: user.id,
          email: user.email,
          fullName: user.fullName,
          password: user.password,
        ),
      );

      emit(UserAdded(users: users));
    });
  }
}
