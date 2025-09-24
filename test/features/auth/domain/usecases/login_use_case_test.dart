import 'package:flutter_test/flutter_test.dart';
import 'package:twitter/features/auth/domain/entities/user_session_entity.dart';
import 'package:twitter/features/auth/domain/usecases/login_use_case.dart';

import '../../data/repository/mock_auth_repository.dart';

void main() {
  group('LoginUseCase test', () {
    late LoginUseCase loginUseCase;

    setUp(() {
      loginUseCase = LoginUseCase(authRepository: MockAuthRepository());
    });

    test('Should login user successfully and return token', () async {
      final String email = "vova.konoplitskyj@gmail.com";
      final String password = "qwerty";

      final result = await loginUseCase.call(email: email, password: password);

      expect(result, isA<UserSessionEntity>());
      expect(result.email, email);
      expect(result.token, 'token');
    });

    test('Should return an error with empty email', () {
      final String email = "vova.konoplitskyj";
      final String password = "qwerty";

      expect(
        () async => await loginUseCase.call(email: email, password: password),
        throwsA(isA<Exception>()),
      );
    });
  });
}
