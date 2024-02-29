import 'package:tdd_clean_architecture/core/usecase/usecase.dart';
import 'package:tdd_clean_architecture/core/utils/typedef.dart';
import 'package:tdd_clean_architecture/src/domain/entities/user.dart';
import 'package:tdd_clean_architecture/src/domain/repositories/authtentication_repository.dart';

class GetUser extends UseCaseWithOutParams<List<User>> {
  final AuthenticationRepository _repository;

  GetUser(this._repository);

  @override
  ResultFuture<List<User>> call() async => _repository.getUsers();
}
