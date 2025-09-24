import 'package:twitter/features/feed/domain/entities/post_entity.dart';
import 'package:twitter/features/feed/domain/repository/post_repository.dart';

class FetchPostUseCase {
  final PostRepository postRepository;

  FetchPostUseCase({required this.postRepository});

  Future<List<PostEntity>> call({required String? currentUserId}) async {
    final result = postRepository.fetchPosts(currentUserId: currentUserId);
    return result;
  }
}
