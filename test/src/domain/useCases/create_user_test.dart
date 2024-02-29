// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_clean_architecture/src/domain/repositories/authtentication_repository.dart';
import 'package:tdd_clean_architecture/src/domain/useCases/create_user.dart';

class MockRepo extends Mock implements AuthenticationRepository {}

void main() {
  late CreateUser usecase;
  late AuthenticationRepository _repository;

  const params = CreateUserParams.empty();
  //CreateUserParams(createdAt: 'createdAt', name: 'name', avatar: 'avatar');
  setUp(() {
    _repository = MockRepo();
    usecase = CreateUser(_repository);
  });

  test('shoul call [AuthRepository.createuser]', () async {
    when(
      () => _repository.createUser(
          createdAt: any(named: 'createdAt'),
          name: any(named: 'name'),
          avatar: any(named: 'avatar')),
    ).thenAnswer((invocation) async => const Right(null));
    final response = await usecase(params);
    expect(response, equals(const Right(null)));
    verify(() => _repository.createUser(
        name: params.name,
        avatar: params.avatar,
        createdAt: params.createdAt)).called(1);
    verifyNoMoreInteractions(_repository);
  });
}
