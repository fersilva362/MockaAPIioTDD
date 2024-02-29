part of 'authentication_bloc.dart';

sealed class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

final class AuthenticationInitial extends AuthenticationState {}

class CreatingUser extends AuthenticationState {}

class GettingUser extends AuthenticationState {}

class UserCreated extends AuthenticationState {}

class UserLoaded extends AuthenticationState {
  final List<User> users;

  const UserLoaded({required this.users});
  @override
  List<Object> get props => users.map((user) => user.id).toList();
}

// ignore: camel_case_types
class authenticationError extends AuthenticationState {
  final String message;

  const authenticationError(this.message);
  @override
  List<String> get props => [message];
}
