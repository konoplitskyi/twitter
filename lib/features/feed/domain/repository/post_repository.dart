import 'package:twitter/features/feed/domain/entities/post_entity.dart';

abstract class PostRepository {
  Future<List<PostEntity>> fetchPosts({required String? currentUserId});
  Future<bool> createPost({required PostEntity post});
  Future<bool> likePost({required String postId, required String userId});
}
