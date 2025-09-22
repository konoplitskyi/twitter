import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:twitter/features/auth/data/datasources/session_local_data_source.dart';
import 'package:twitter/features/auth/data/repository/mock_auth_repository.dart';
import 'package:twitter/features/auth/domain/services/user_session_service.dart';
import 'package:twitter/features/auth/domain/usecases/login_use_case.dart';
import 'package:twitter/features/auth/domain/usecases/register_use_case.dart';
import 'package:twitter/features/auth/presentation/Login/bloc/Login_bloc.dart';
import 'package:twitter/features/auth/presentation/login/screens/login_page.dart';
import 'package:twitter/features/auth/presentation/register/bloc/register_bloc.dart';
import 'package:twitter/features/auth/presentation/register/screens/register_page.dart';
import 'package:twitter/features/splash/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    final SessionLocalDataSource sessionLocalDataSource =
        SessionLocalDataSourceImpl(secureStorage: secureStorage);
    final UserSessionService userSessionService = UserSessionService(
      sessionLocalDataSource: sessionLocalDataSource,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterBloc(
            registerUseCase: RegisterUseCase(
              authRepository: MockAuthRepository(),
            ),
            userSessionService: userSessionService,
          ),
        ),
        BlocProvider(
          create: (context) => LoginBloc(
            loginUseCase: LoginUseCase(authRepository: MockAuthRepository()),
            userSessionService: userSessionService,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        home: SplashPage(userSessionService: userSessionService),
        routes: {
          '/register': (_) => RegisterPage(),
          '/login': (_) => LoginPage(),
          '/home': (_) => HomePage(),
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Home page'));
  }
}
