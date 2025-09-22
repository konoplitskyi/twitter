import 'package:twitter/features/auth/domain/models/login_params.dart';
import 'package:twitter/features/auth/domain/repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase({required this.authRepository});

  Future<String> call({required String email, required String password}) async {
    final loginParams = LoginParams(email: email, password: password);
    final token = await authRepository.login(loginParams: loginParams);

    return token;
  }
}
