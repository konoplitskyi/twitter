import 'package:flutter_test/flutter_test.dart';
import 'package:twitter/features/feed/domain/entities/post_entity.dart';
import 'package:twitter/features/feed/domain/usecases/fetch_post_use_case.dart';

import '../../data/repository/mock_posts_repository.dart';

void main() {
  group('FetchFeedUseCase test', () {
    late MockPostsRepository mockPostsRepository;
    late MockPostsWithErrorRepository mockPostsWithErrorRepository;

    setUp(() {
      mockPostsRepository = MockPostsRepository();
      mockPostsWithErrorRepository = MockPostsWithErrorRepository();
    });

    test('Should return list of post', () async {
      FetchPostUseCase fetchPostUseCase = FetchPostUseCase(
        postRepository: mockPostsRepository,
      );
      final result = await fetchPostUseCase.call(currentUserId: '123');

      expect(result, isInstanceOf<List<PostEntity>>());
      expect(result.length, greaterThan(0));
    });

    test('Should return an error if repository is compromise', () async {
      FetchPostUseCase fetchPostUseCase = FetchPostUseCase(
        postRepository: mockPostsWithErrorRepository,
      );

      expect(
        () async => await fetchPostUseCase.call(currentUserId: '123'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
