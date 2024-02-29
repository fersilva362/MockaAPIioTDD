import 'package:equatable/equatable.dart';
import 'package:tdd_clean_architecture/core/usecase/usecase.dart';
import 'package:tdd_clean_architecture/core/utils/typedef.dart';
import 'package:tdd_clean_architecture/src/domain/repositories/authtentication_repository.dart';

class CreateUser extends UseCaseWithParams<void, CreateUserParams> {
  final AuthenticationRepository _repository;

  CreateUser(this._repository);

  @override
  ResultVoid call(params) async => _repository.createUser(
      createdAt: params.createdAt, name: params.name, avatar: params.avatar);
}

class CreateUserParams extends Equatable {
  const CreateUserParams(
      {required this.createdAt, required this.name, required this.avatar});

  final String createdAt;
  final String name;
  final String avatar;
  const CreateUserParams.empty()
      : this(createdAt: 'createdAt', name: 'name', avatar: 'avatar');

  @override
  List<Object?> get props => [name, createdAt, avatar];
}
