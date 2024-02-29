import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String avatar;
  final String createdAt;

  const User(
      {required this.id,
      required this.name,
      required this.avatar,
      required this.createdAt});

  const User.empty()
      : this(avatar: 'avatar', id: '1', name: 'name', createdAt: 'createdAt');

  @override
  List<Object?> get props => [id, name, avatar];
}
