import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:twitter/features/auth/data/datasources/session_local_data_source.dart';
import 'package:twitter/features/auth/data/repository/supabase_auth_repository.dart';
import 'package:twitter/features/auth/domain/services/user_session_service.dart';
import 'package:twitter/features/auth/domain/usecases/login_use_case.dart';
import 'package:twitter/features/auth/domain/usecases/register_use_case.dart';
import 'package:twitter/features/auth/presentation/Login/bloc/Login_bloc.dart';
import 'package:twitter/features/auth/presentation/login/screens/login_page.dart';
import 'package:twitter/features/auth/presentation/register/bloc/register_bloc.dart';
import 'package:twitter/features/auth/presentation/register/screens/register_page.dart';
import 'package:twitter/features/feed/data/repository/supabase_post_repository.dart';
import 'package:twitter/features/feed/domain/usecases/create_post_use_case.dart';
import 'package:twitter/features/feed/domain/usecases/fetch_post_use_case.dart';
import 'package:twitter/features/feed/domain/usecases/like_post_use_case.dart';
import 'package:twitter/features/feed/presentation/bloc/create_post/create_post_bloc.dart';
import 'package:twitter/features/feed/presentation/bloc/feed/feed_bloc.dart';
import 'package:twitter/features/feed/presentation/screens/feed_page.dart';
import 'package:twitter/features/splash/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://mbfpleaqhduqprrdhxln.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1iZnBsZWFxaGR1cXBycmRoeGxuIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1ODY2MjM1NiwiZXhwIjoyMDc0MjM4MzU2fQ.ZzV7PtJWleZOukoEhviwEngZ7QLNW91mrMkB7qr6OGI',
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    final SessionLocalDataSource sessionLocalDataSource =
        SessionLocalDataSourceImpl(secureStorage: secureStorage);
    final UserSessionService userSessionService = UserSessionService(
      sessionLocalDataSource: sessionLocalDataSource,
    );

    return Provider<UserSessionService>.value(
      value: userSessionService,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => RegisterBloc(
              registerUseCase: RegisterUseCase(
                authRepository: SupabaseAuthRepository(client: supabase),
              ),
              userSessionService: userSessionService,
            ),
          ),
          BlocProvider(
            create: (context) => LoginBloc(
              loginUseCase: LoginUseCase(
                authRepository: SupabaseAuthRepository(client: supabase),
              ),
              userSessionService: userSessionService,
            ),
          ),
          BlocProvider(
            create: (context) => FeedBloc(
              fetchPostUseCase: FetchPostUseCase(
                postRepository: SupabasePostRepository(client: supabase),
              ),
              likePostUseCase: LikePostUseCase(
                postRepository: SupabasePostRepository(client: supabase),
              ),
              userSessionService: userSessionService,
            ),
          ),
          BlocProvider(
            create: (context) => CreatePostBloc(
              createPostUseCase: CreatePostUseCase(
                postRepository: SupabasePostRepository(client: supabase),
              ),
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
            '/home': (_) => FeedPage(),
            '/splash': (_) =>
                SplashPage(userSessionService: userSessionService),
          },
        ),
      ),
    );
  }
}
