import 'package:twitter/features/feed/domain/entities/post_entity.dart';
import 'package:twitter/features/feed/domain/repository/post_repository.dart';

class MockPostsRepository implements PostRepository {
  @override
  Future<List<PostEntity>> fetchPosts({required String? currentUserId}) async {
    return [
      PostEntity(
        userId: '123',
        username: 'vokko',
        content: 'test',
        createdAt: DateTime.now(),
      ),
    ];
  }

  @override
  Future<bool> createPost({required PostEntity post}) async {
    return true;
  }

  @override
  Future<bool> likePost({
    required String postId,
    required String userId,
  }) async {
    return true;
  }
}

class MockPostsWithErrorRepository implements PostRepository {
  @override
  Future<List<PostEntity>> fetchPosts({required String? currentUserId}) {
    throw Exception('Something broke');
  }

  @override
  Future<bool> createPost({required PostEntity post}) {
    throw Exception('Something broke');
  }

  @override
  Future<bool> likePost({required String postId, required String userId}) {
    throw Exception('Something broke');
  }
}
