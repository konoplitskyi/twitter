import 'package:flutter_test/flutter_test.dart';
import 'package:twitter/features/auth/domain/entities/user_session_entity.dart';
import 'package:twitter/features/auth/domain/usecases/register_use_case.dart';

import '../../data/repository/mock_auth_repository.dart';

void main() {
  group('RegisterUseCase test', () {
    late RegisterUseCase registerUseCase;
    late RegisterUseCase registerWithErrorUseCase;

    setUp(() {
      registerUseCase = RegisterUseCase(authRepository: MockAuthRepository());
      registerWithErrorUseCase = RegisterUseCase(
        authRepository: MockAuthWithErrorRepository(),
      );
    });

    test('Should register user successfully and return token', () async {
      final String email = "vova.konoplitskyj@gmail.com";
      final String username = "vokkO_o";
      final String password = "qwerty";

      final result = await registerUseCase.call(
        email: email,
        username: username,
        password: password,
      );

      expect(result, isA<UserSessionEntity>());
      expect(result.email, email);
      expect(result.token, 'token');
    });

    test('Should return an error with empty email', () async {
      final String email = "";
      final String username = "vokkO_o";
      final String password = "qwerty";

      expect(
        () async => await registerUseCase.call(
          email: email,
          username: username,
          password: password,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('Should return an error if email have a wrong format', () async {
      final String email = "vova.konoplitskyj";
      final String username = "vokkO_o";
      final String password = "qwerty";

      expect(
        () async => await registerUseCase.call(
          email: email,
          username: username,
          password: password,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test(
      'Should return an error if password do not have at least 4 characters',
      () async {
        final String email = "vova.konoplitskyj@gmail.com";
        final String username = "vokkO_o";
        final String password = "123";

        expect(
          () async => await registerUseCase.call(
            email: email,
            username: username,
            password: password,
          ),
          throwsA(isA<Exception>()),
        );
      },
    );

    test('Should return an error if username is empty', () async {
      final String email = "vova.konoplitskyj@gmail.com";
      final String username = "";
      final String password = "qwerty";

      expect(
        () async => await registerUseCase.call(
          email: email,
          username: username,
          password: password,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('Should return an error if username is empty', () async {
      final String email = "vova.konoplitskyj@gmail.com";
      final String username = "vokkO_o";
      final String password = "qwerty";

      expect(
        () async => await registerWithErrorUseCase.call(
          email: email,
          username: username,
          password: password,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
