import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/models/user.dart';
import 'package:meta/meta.dart';
import 'package:ecommerce_app/services/users_services.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserService _userService = UserService();
  UserCubit() : super(UserInitial());

  // إضافة مستخدم إلى Firestore
  Future<void> addUserToFirestore(UserData user) async {
    emit(UserAdding());
    try {
      await _userService.createUser(user);
      emit(UserAdded(users: [user])); // يمكنك تعديلها حسب الحاجة
    } catch (e) {
      emit(UserAddField(message: e.toString()));
    }
  }

  // جلب مستخدم من Firestore
  Future<void> getUserFromFirestore(String id) async {
    emit(UserSearching());
    try {
      final user = await _userService.getUserById(id);
      if (user != null) {
        emit(UserSearched(user: user));
      } else {
        emit(UserSearchNotFound());
      }
    } catch (e) {
      emit(UserSearchField(message: e.toString()));
    }
  }

  // // تحديث مستخدم في Firestore
  // Future<void> updateUserInFirestore(UserData user) async {
  //   emit(UserUpdating());
  //   try {
  //     await _userService.updateUser(user);
  //     emit(UserUpdated(user: user));
  //   } catch (e) {
  //     emit(UserAddField(message: e.toString()));
  //   }
  // }

  // // حذف مستخدم من Firestore
  // Future<void> deleteUserFromFirestore(String id) async {
  //   emit(UserDeleting());
  //   try {
  //     await _userService.deleteUser(id);
  //     emit(UserDeleted(id: id));
  //   } catch (e) {
  //     emit(UserError(message: e.toString()));
  //   }
  // }

  // جلب جميع المستخدمين
  // Future<void> getAllUsersFromFirestore() async {
  //   emit(UserLoading());
  //   try {
  //     final users = await _userService.getAllUsers();
  //     emit(UserLoaded(users: users));
  //   } catch (e) {
  //     emit(UserError(message: e.toString()));
  //   }
  // }
}
