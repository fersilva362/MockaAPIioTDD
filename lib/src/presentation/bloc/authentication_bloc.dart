import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd_clean_architecture/src/domain/entities/user.dart';
import 'package:tdd_clean_architecture/src/domain/useCases/create_user.dart';
import 'package:tdd_clean_architecture/src/domain/useCases/get_users.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(this._createUser, this._getUsers)
      : super(AuthenticationInitial()) {
    on<CreateUserEvent>(_createUserHandler);
    on<GetUserEvent>(_getUserHandler);
  }

  final CreateUser _createUser;
  final GetUser _getUsers;

  Future<void> _createUserHandler(
      CreateUserEvent event, Emitter<AuthenticationState> emit) async {
    emit(CreatingUser());
    final result = await _createUser(CreateUserParams(
        createdAt: event.createdAt, name: event.name, avatar: event.avatar));
    result.fold(
        (l) => emit(authenticationError('${l.statusCode}, Error:${l.message}')),
        (_) => emit(UserCreated()));
  }

  Future<void> _getUserHandler(
      GetUserEvent event, Emitter<AuthenticationState> emit) async {
    emit(GettingUser());
    final result = await _getUsers();
    result.fold((l) => emit(authenticationError(l.messageError)),
        (users) => emit(UserLoaded(users: users)));
  }
}
