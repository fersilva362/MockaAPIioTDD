import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_clean_architecture/core/errors/failure.dart';
import 'package:tdd_clean_architecture/src/domain/useCases/create_user.dart';
import 'package:tdd_clean_architecture/src/domain/useCases/get_users.dart';
import 'package:tdd_clean_architecture/src/presentation/cubit/authentication_cubit.dart';

class MockGetUser extends Mock implements GetUser {}

class MockCreateUser extends Mock implements CreateUser {}

void main() {
  late GetUser getUser;
  late CreateUser createUser;
  late AuthenticationCubit cubit;
  const tCreateUserParams = CreateUserParams.empty();
  const tServerFailure = ApiFailure(message: 'message', statusCode: 500);
  setUp(() {
    getUser = MockGetUser();
    createUser = MockCreateUser();
    cubit = AuthenticationCubit(createUser, getUser);
    registerFallbackValue(tCreateUserParams);
  });
  tearDown(() => cubit.close());
  test('should initial state [AuthenticationInitial]', () async {
    expect(cubit.state, AuthenticationInitial());
  });
  group('createUser', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
        'emits [CreatingUser, UserCreate] when succesfully.',
        build: () {
          when(() => createUser.call(any()))
              .thenAnswer((_) async => const Right(null));
          return cubit;
        },
        act: (cubit) => cubit.createUser(
            createdAt: 'createdAt', name: 'name', avatar: 'avatar'),
        expect: () => <AuthenticationState>[CreatingUser(), UserCreated()],
        verify: (_) {
          verify(
            () => createUser.call(tCreateUserParams),
          );
          verifyNoMoreInteractions(createUser);
        });
    blocTest<AuthenticationCubit, AuthenticationState>(
      'emits [CreatingUser, authenticationError] when is unsuccesfully.',
      build: () {
        when(() => createUser.call(any()))
            .thenAnswer((_) async => const Left(tServerFailure));

        return cubit;
      },
      act: (cubit) => cubit.createUser(
          createdAt: 'createdAt', name: 'name', avatar: 'avatar'),
      expect: () => <AuthenticationState>[
        CreatingUser(),
        AuthenticationError(tServerFailure.messageError)
      ],
      verify: (_) {
        verify(
          () => createUser.call(tCreateUserParams),
        ).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );
  });
  group('getUser', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'emits GettingUser, UserLoaded] when is succesfully.',
      build: () {
        when(
          () => getUser.call(),
        ).thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (cubit) {
        return cubit.getUser.call();
      },
      expect: () => [GettingUser(), const UserLoaded(users: [])],
      verify: (_) {
        verify(
          () => getUser.call(),
        ).called(1);
        verifyNoMoreInteractions(getUser);
      },
    );
    blocTest<AuthenticationCubit, AuthenticationState>(
      'emits [USerloading , AuthetnictionErro] when is unsuccesfully.',
      build: () {
        when(() => getUser.call())
            .thenAnswer((_) async => const Left(tServerFailure));

        return cubit;
      },
      act: (cubit) => cubit.getUser(),
      expect: () => <AuthenticationState>[
        GettingUser(),
        AuthenticationError(tServerFailure.messageError)
      ],
      verify: (_) {
        verify(
          () => getUser.call(),
        ).called(1);
        verifyNoMoreInteractions(getUser);
      },
    );
  });
}
