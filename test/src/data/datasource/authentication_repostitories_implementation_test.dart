import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tdd_clean_architecture/core/errors/exception.dart';
import 'package:tdd_clean_architecture/src/data/datasources/authentication_remote_datasource.dart';
import 'package:tdd_clean_architecture/src/data/models/user_model.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthenticationRemoteDataSource remoteDataSource;
  setUp(() {
    client = MockClient();
    remoteDataSource = AuthRemoteDataimpl(client);
    registerFallbackValue(Uri());
  });

  group('createUser', () {
    group('should complete succesfully when return 200 or 201 ', () {
      test('should completed succesfully when return 200 or 201', () async {
        when(
          () => client.post(any(),
              body: any(named: 'body'), headers: any(named: 'headers')),
        ).thenAnswer(
            (_) async => http.Response('User created succesfully', 201));

        final response = remoteDataSource.createUser(
            createdAt: 'createdAt', name: 'name', avatar: 'avatar');

        expect(() => response, completes);
        verify(() => client.post(
            Uri.parse('https://65ae6f331dfbae409a74d30e.mockapi.io/users'),
            body: jsonEncode(
                {'createdAt': 'createdAt', 'name': 'name', 'avatar': 'avatar'}),
            headers: {'Content-Type': 'application/json '})).called(1);
        verifyNoMoreInteractions(client);
      });
      test('should throw [ApiException] when return is not 200 or 201',
          () async {
        when(
          () => client.post(any(),
              body: any(named: 'body'), headers: any(named: 'headers')),
        ).thenAnswer((_) async => http.Response('invalid name user', 400));
        final result = await remoteDataSource.createUser(
            createdAt: 'createdAt', name: 'name', avatar: 'avatar');

        expect(
            () => result,
            throwsA(const ServerException(
                message: 'invalid name user', statusCode: 400)));
        verify(() => client.post(
            Uri.parse('https://65ae6f331dfbae409a74d30e.mockapi.io/users'),
            body: jsonEncode(
              {'createdAt': 'createdAt', 'name': 'name', 'avatar': 'avatar'},
            ),
            headers: {'Content-Type': 'application/json '})).called(1);
        verifyNoMoreInteractions(client);
      });
    });
  });
  group('getUser', () {
    test('should return a [Lis<UserModel>] when the status code is 200 or 201',
        () async {
      when(
        () => client.get(any()),
      ).thenAnswer((_) async =>
          http.Response(jsonEncode([const UserModel.empty()]), 200));
      final result = await remoteDataSource.getUsers();
      expect(result, equals([const UserModel.empty()]));
      verify(
        () => client.get(
            Uri.parse('https://65ae6f331dfbae409a74d30e.mockapi.io/users')),
      ).called(1);
      verifyNoMoreInteractions(client);
    });

    test('should retur [Api exception] when the status code is not 200 or 201',
        () async {
      when(
        () => client.get(any()),
      ).thenAnswer((_) async => http.Response('Unknown error', 500));
      final result = remoteDataSource.getUsers();
      expect(
          result,
          throwsA(const ServerException(
              message: 'Unknown error', statusCode: 500)));
      verify(
        () => client.get(
            Uri.parse('https://65ae6f331dfbae409a74d30e.mockapi.io/users')),
      ).called(1);
      verifyNoMoreInteractions(client);
    });
  });
}
