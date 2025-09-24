import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:twitter/features/auth/domain/usecases/register_use_case.dart';
import 'package:twitter/features/auth/presentation/register/bloc/register_bloc.dart';
import 'package:twitter/features/auth/presentation/register/bloc/register_event.dart';
import 'package:twitter/features/auth/presentation/register/bloc/register_state.dart';

import '../../data/repository/mock_auth_repository.dart';
import '../../domain/services/mock_user_session_service.dart';

void main() {
  group('RegisterBloc test', () {
    late RegisterBloc registerBloc;
    late RegisterBloc registerBlocWithRepositoryError;
    final MockUserSessionService mockUserSessionService =
        MockUserSessionService();

    setUp(() {
      registerBloc = RegisterBloc(
        registerUseCase: RegisterUseCase(authRepository: MockAuthRepository()),
        userSessionService: mockUserSessionService,
      );
      registerBlocWithRepositoryError = RegisterBloc(
        registerUseCase: RegisterUseCase(
          authRepository: MockAuthWithErrorRepository(),
        ),
        userSessionService: mockUserSessionService,
      );
    });

    blocTest(
      'emit [RegisterLoading, RegisterSuccess] when register in successful',
      build: () => registerBloc,

      act: (bloc) => bloc.add(
        RegisterSubmitted(
          email: 'vova.konoplitskyj@gmail.com',
          username: 'vivkotwitter',
          password: 'qwerty',
        ),
      ),
      expect: () => [RegisterLoading(), RegisterSuccess()],
    );

    blocTest(
      'emit [RegisterLoading, RegisterFailure] when email is wrong',
      build: () => registerBloc,

      act: (bloc) => bloc.add(
        RegisterSubmitted(
          email: 'vova.konoplitskyj',
          username: 'vivkotwitter',
          password: 'qwerty',
        ),
      ),
      expect: () => [RegisterLoading(), isA<RegisterFailure>()],
    );

    blocTest(
      'emit [RegisterLoading, RegisterFailure] when repository return an error',
      build: () => registerBlocWithRepositoryError,

      act: (bloc) => bloc.add(
        RegisterSubmitted(
          email: 'vova.konoplitskyj@gmail.com',
          username: 'vivkotwitter',
          password: 'qwerty',
        ),
      ),
      expect: () => [RegisterLoading(), isA<RegisterFailure>()],
    );
  });
}
