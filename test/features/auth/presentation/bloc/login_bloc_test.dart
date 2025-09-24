import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:twitter/features/auth/domain/usecases/login_use_case.dart';
import 'package:twitter/features/auth/presentation/Login/bloc/Login_bloc.dart';
import 'package:twitter/features/auth/presentation/login/bloc/login_event.dart';
import 'package:twitter/features/auth/presentation/login/bloc/login_state.dart';

import '../../data/repository/mock_auth_repository.dart';
import '../../domain/services/mock_user_session_service.dart';

void main() {
  group('LoginBloc test', () {
    late LoginBloc loginBloc;
    late LoginBloc loginBlocWithRepositoryError;
    final MockUserSessionService mockUserSessionService =
        MockUserSessionService();

    setUp(() {
      loginBloc = LoginBloc(
        loginUseCase: LoginUseCase(authRepository: MockAuthRepository()),
        userSessionService: mockUserSessionService,
      );
      loginBlocWithRepositoryError = LoginBloc(
        loginUseCase: LoginUseCase(
          authRepository: MockAuthWithErrorRepository(),
        ),
        userSessionService: mockUserSessionService,
      );
    });

    blocTest(
      'emit [LoginLoading, LoginSuccess] when login in successful',
      build: () => loginBloc,

      act: (bloc) => bloc.add(
        LoginSubmitted(
          email: 'vova.konoplitskyj@gmail.com',
          password: 'qwerty',
        ),
      ),
      expect: () => [LoginLoading(), LoginSuccess()],
    );

    blocTest(
      'emit [LoginLoading, LoginFailure] when password is wrong',
      build: () => loginBloc,

      act: (bloc) => bloc.add(
        LoginSubmitted(email: 'vova.konoplitskyj@gmail.com', password: '0'),
      ),
      expect: () => [LoginLoading(), isA<LoginFailure>()],
    );

    blocTest(
      'emit [RegisterLoading, RegisterFailure] when repository return an error',
      build: () => loginBlocWithRepositoryError,

      act: (bloc) => bloc.add(
        LoginSubmitted(
          email: 'vova.konoplitskyj@gmail.com',
          password: 'qwerty',
        ),
      ),
      expect: () => [LoginLoading(), isA<LoginFailure>()],
    );
  });
}
