import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:twitter/core/utils.dart';
import 'package:twitter/features/feed/domain/entities/post_entity.dart';
import 'package:twitter/features/feed/domain/repository/post_repository.dart';

class SupabasePostRepository extends PostRepository {
  final SupabaseClient client;

  SupabasePostRepository({required this.client});

  static const String postsTableName = 'posts';
  static const String likesTableName = 'likes';

  @override
  Future<bool> createPost({required PostEntity post}) async {
    try {
      final data = post.toJson();
      await client.from(postsTableName).insert(data);

      return true;
    } catch (e) {
      throw Exception('Failed to create post: ${formatError(e)}');
    }
  }

  @override
  Future<List<PostEntity>> fetchPosts({String? currentUserId}) async {
    try {
      final postResponse = await client
          .from(postsTableName)
          .select()
          .order('created_at', ascending: false);

      final likesResponse = await client
          .from(likesTableName)
          .select('post_id')
          .eq('user_id', currentUserId ?? '');

      final likedPostIds = (likesResponse as List)
          .map((like) => like['post_id'] as String)
          .toSet();

      return (postResponse as List).map((json) {
        final post = PostEntity.fromJson(json);
        final isLiked = likedPostIds.contains(post.id);
        return post.copyWith(isLikedByCurrentUser: isLiked);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch posts: ${formatError(e)}');
    }
  }

  @override
  Future<bool> likePost({
    required String postId,
    required String userId,
  }) async {
    try {
      final response = await client
          .from(postsTableName)
          .select('likes_count')
          .eq('id', postId)
          .single();

      final currentLikes = response['likes_count'] ?? 0;

      final existingLike = await client
          .from(likesTableName)
          .select()
          .eq('user_id', userId)
          .eq('post_id', postId)
          .maybeSingle();

      if (existingLike != null) {
        await client
            .from(likesTableName)
            .delete()
            .eq('user_id', userId)
            .eq('post_id', postId);

        await client
            .from(postsTableName)
            .update({'likes_count': currentLikes - 1})
            .eq('id', postId);
      } else {
        await client.from(likesTableName).insert({
          'user_id': userId,
          'post_id': postId,
        });

        await client
            .from(postsTableName)
            .update({'likes_count': currentLikes + 1})
            .eq('id', postId);
      }

      return true;
    } catch (e) {
      throw Exception('Failed to like post: $e');
    }
  }
}
