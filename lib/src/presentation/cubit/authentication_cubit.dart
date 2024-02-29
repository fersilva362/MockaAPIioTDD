// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:tdd_clean_architecture/src/domain/entities/user.dart';
import 'package:tdd_clean_architecture/src/domain/useCases/create_user.dart';
import 'package:tdd_clean_architecture/src/domain/useCases/get_users.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final CreateUser _createUser;
  final GetUser _getUser;

  AuthenticationCubit(
    this._createUser,
    this._getUser,
  ) : super(AuthenticationInitial());

  Future<void> createUser(
      {required String createdAt,
      required String name,
      required String avatar}) async {
    emit(CreatingUser());
    final result = await _createUser.call(
        CreateUserParams(createdAt: createdAt, name: name, avatar: avatar));
    result.fold((l) => emit(AuthenticationError(l.messageError)),
        (_) => emit(UserCreated()));
  }

  Future<void> getUser() async {
    emit(GettingUser());
    final result = await _getUser();
    result.fold((l) => emit(AuthenticationError(l.messageError)),
        (users) => emit(UserLoaded(users: users)));
  }
}
