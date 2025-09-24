import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:twitter/features/feed/domain/usecases/create_post_use_case.dart';
import 'package:twitter/features/feed/presentation/bloc/create_post/create_post_bloc.dart';

import '../../data/repository/mock_posts_repository.dart';

void main() {
  group('FeedBloc test', () {
    late CreatePostBloc createPostBloc;
    late CreatePostBloc createPostBlocWithError;

    setUp(() {
      createPostBloc = CreatePostBloc(
        createPostUseCase: CreatePostUseCase(
          postRepository: MockPostsRepository(),
        ),
      );
      createPostBlocWithError = CreatePostBloc(
        createPostUseCase: CreatePostUseCase(
          postRepository: MockPostsWithErrorRepository(),
        ),
      );
    });

    blocTest(
      'emit [CreatePostLoading, CreatePostSuccess] when post are created successfully',
      build: () => createPostBloc,
      act: (bloc) => bloc.add(
        CreatePostRequested(
          username: "vokkO_o",
          content: "test",
          userId: "123",
          imageUrl: "imageUrl",
        ),
      ),
      expect: () => [CreatePostLoading(), isA<CreatePostSuccess>()],
    );

    blocTest(
      'emit [CreatePostLoading, CreatePostFailure] when post failed to create',
      build: () => createPostBlocWithError,
      act: (bloc) => bloc.add(
        CreatePostRequested(
          username: "vokkO_o",
          content: "test",
          userId: "123",
          imageUrl: "imageUrl",
        ),
      ),
      expect: () => [CreatePostLoading(), isA<CreatePostFailure>()],
    );
  });
}
