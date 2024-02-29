// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_clean_architecture/core/errors/exception.dart';
import 'package:tdd_clean_architecture/core/errors/failure.dart';
import 'package:tdd_clean_architecture/src/data/datasources/authentication_remote_datasource.dart';
import 'package:tdd_clean_architecture/src/data/repositories/authentication_repostitories_implementation.dart';
import 'package:tdd_clean_architecture/src/domain/entities/user.dart';

class MockAuthRemoteData extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late MockAuthRemoteData _remoteDataSource;
  late AuthenticationRepoImplemtation repoImplemtation;
  setUp(() {
    _remoteDataSource = MockAuthRemoteData();
    repoImplemtation = AuthenticationRepoImplemtation(_remoteDataSource);
  });

  group('createUSer', () {
    /* test('should call [RemoteDataSource.createUser()]', () async {
      when(
        () {
          _remoteDataSource.createUser(
              createdAt: any(named: 'createdAt'),
              name: any(named: 'name'),
              avatar: any(named: 'avatar'));
        },
      ).thenAnswer(
        (_) async => Future.value(),
      );
      final result = await repoImplemtation.createUser(
          createdAt: 'createdAt', name: 'name', avatar: 'avatar');

      expect(result, equals(Right(null)));
      verify(
        () => _remoteDataSource.createUser(
            createdAt: 'createdAt', name: 'name', avatar: 'avatar'),
      ).called(1);
      verifyNoMoreInteractions(_remoteDataSource);
    });
  */
    test('should return [ServerFailure]', () async {
      when(
        () {
          _remoteDataSource.createUser(
              createdAt: any(named: 'createdAt'),
              name: any(named: 'name'),
              avatar: any(named: 'avatar'));
        },
      ).thenThrow(
          const ServerException(message: 'Unknown Error', statusCode: 500));

      final result = await repoImplemtation.createUser(
          createdAt: 'createdAt', name: 'name', avatar: 'avatar');
      expect(
          result,
          equals(const Left(ApiFailure(
            message: 'Unknown Error',
            statusCode: 500,
          ))));

      verify(
        () => _remoteDataSource.createUser(
            createdAt: 'createdAt', name: 'name', avatar: 'avatar'),
      ).called(1);
      verifyNoMoreInteractions(_remoteDataSource);
    });
  });
  group('getUser', () {
    test('should call [getUser] and return [List<User>]', () async {
      when(
        () => _remoteDataSource.getUsers(),
      ).thenAnswer((_) async => []);
      final result = await repoImplemtation.getUsers();
      expect(result, isA<Right<dynamic, List<User>>>());
      verify(
        () => _remoteDataSource.getUsers(),
      ).called(1);
      verifyNoMoreInteractions(_remoteDataSource);
    });
    test('should call [getUser] and return [serverException] ', () async {
      when(
        () => _remoteDataSource.getUsers(),
      ).thenThrow(
          const ServerException(message: 'error Unknown', statusCode: 500));

      final result = await repoImplemtation.getUsers();

      expect(
          result,
          equals(const Left(
              ApiFailure(message: 'error Unknown', statusCode: 500))));

      verify(
        () => _remoteDataSource.getUsers(),
      ).called(1);
      verifyNoMoreInteractions(_remoteDataSource);
    });
  });
}
