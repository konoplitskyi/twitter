import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter/core/utils.dart';
import 'package:twitter/features/auth/domain/services/user_session_service.dart';
import 'package:twitter/features/auth/domain/usecases/register_use_case.dart';
import 'package:twitter/features/auth/presentation/register/bloc/register_event.dart';
import 'package:twitter/features/auth/presentation/register/bloc/register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterUseCase registerUseCase;
  UserSessionService userSessionService;

  RegisterBloc({
    required this.registerUseCase,
    required this.userSessionService,
  }) : super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(RegisterSubmitted event, emit) async {
    emit(RegisterLoading());
    try {
      final userSession = await registerUseCase.call(
        email: event.email,
        username: event.username,
        password: event.password,
      );
      await userSessionService.persistSession(userSession: userSession);
      emit(RegisterSuccess());
    } on Exception catch (e) {
      emit(RegisterFailure(message: formatError(e)));
    }
  }
}
