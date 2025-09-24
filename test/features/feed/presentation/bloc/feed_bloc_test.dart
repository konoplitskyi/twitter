import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:twitter/features/feed/domain/usecases/fetch_post_use_case.dart';
import 'package:twitter/features/feed/domain/usecases/like_post_use_case.dart';
import 'package:twitter/features/feed/presentation/bloc/feed/feed_bloc.dart';

import '../../../auth/domain/services/mock_user_session_service.dart';
import '../../data/repository/mock_posts_repository.dart';

void main() {
  group('FeedBloc test', () {
    late FeedBloc feedBloc;
    late FeedBloc feedBlocWithError;
    MockUserSessionService mockUserSessionService = MockUserSessionService();

    setUp(() {
      feedBloc = FeedBloc(
        fetchPostUseCase: FetchPostUseCase(
          postRepository: MockPostsRepository(),
        ),
        likePostUseCase: LikePostUseCase(postRepository: MockPostsRepository()),
        userSessionService: mockUserSessionService,
      );
      feedBlocWithError = FeedBloc(
        fetchPostUseCase: FetchPostUseCase(
          postRepository: MockPostsWithErrorRepository(),
        ),
        likePostUseCase: LikePostUseCase(
          postRepository: MockPostsWithErrorRepository(),
        ),
        userSessionService: mockUserSessionService,
      );
    });

    blocTest(
      'emit [FeedLoading, FeedSuccess] when posts are fetched successfully',
      build: () => feedBloc,
      act: (bloc) => bloc.add(FetchPostsRequested()),
      expect: () => [FeedLoading(), isA<FeedLoaded>()],
    );

    blocTest(
      'emit [FeedLoading, FeedFailure] when loaded posts failed',
      build: () => feedBlocWithError,
      act: (bloc) => bloc.add(FetchPostsRequested()),
      expect: () => [FeedLoading(), isA<FeedFailure>()],
    );
  });
}
