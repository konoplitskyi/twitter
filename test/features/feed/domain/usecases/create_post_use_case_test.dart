import 'package:flutter_test/flutter_test.dart';
import 'package:twitter/features/feed/domain/usecases/create_post_use_case.dart';

import '../../data/repository/mock_posts_repository.dart';

void main() {
  group('CreatePostUseCase test', () {
    late MockPostsRepository mockPostsRepository;
    late MockPostsWithErrorRepository mockPostsWithErrorRepository;

    setUp(() {
      mockPostsRepository = MockPostsRepository();
      mockPostsWithErrorRepository = MockPostsWithErrorRepository();
    });

    test('Should create post successfully', () async {
      String userId = "123";
      String username = "vokkO_o";
      String content = "test";
      String imageUrl = "";

      CreatePostUseCase createPostUseCase = CreatePostUseCase(
        postRepository: mockPostsRepository,
      );

      final result = await createPostUseCase.call(
        userId: userId,
        username: username,
        content: content,
        imageUrl: imageUrl,
      );

      expect(result, isTrue);
    });

    test('Should return an error if username or content are empty', () async {
      String userId = "123";
      String username = "";
      String content = "";
      String imageUrl = "";

      CreatePostUseCase createPostUseCase = CreatePostUseCase(
        postRepository: mockPostsRepository,
      );

      expect(
        () async => await createPostUseCase.call(
          userId: userId,
          username: username,
          content: content,
          imageUrl: imageUrl,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test(
      'Should return an Exception if there is an error with the repository',
      () async {
        String userId = "123";
        String username = "vokkO_o";
        String content = "test";
        String imageUrl = "";

        CreatePostUseCase createPostUseCase = CreatePostUseCase(
          postRepository: mockPostsWithErrorRepository,
        );

        expect(
          () async => await createPostUseCase.call(
            userId: userId,
            username: username,
            content: content,
            imageUrl: imageUrl,
          ),
          throwsA(isA<Exception>()),
        );
      },
    );
  });
}
