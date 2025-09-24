import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter/core/utils.dart';
import 'package:twitter/features/auth/domain/services/user_session_service.dart';
import 'package:twitter/features/feed/domain/entities/post_entity.dart';
import 'package:twitter/features/feed/presentation/bloc/feed/feed_bloc.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(radius: 20, backgroundColor: Colors.grey),
              SizedBox(width: 10),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      post.username,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Spacer(),
                    Text(
                      formatDate(post.createdAt),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (post.imageUrl != null && post.imageUrl!.isNotEmpty) ...[
            SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(post.imageUrl!),
            ),
          ],
          const SizedBox(height: 10),

          Text(
            post.content,
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),

          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _PostStat(
                icon: post.isLikedByCurrentUser == true
                    ? Icons.favorite
                    : Icons.favorite_border,
                iconColor: post.isLikedByCurrentUser == true
                    ? Colors.red
                    : Colors.grey,
                count: post.likesCount,
                onTap: () {
                  final userSessionService = context.read<UserSessionService>();
                  userSessionService.getUserSession().then((session) {
                    if (session != null) {
                      if (!context.mounted) return;
                      context.read<FeedBloc>().add(
                        LikePostRequested(postId: post.id!, userId: session.id),
                      );
                    }
                  });
                },
              ),
              _PostStat(
                icon: Icons.comment,
                count: post.commentsCount,
                onTap: () {},
              ),
              _PostStat(
                icon: Icons.loop,
                count: post.repostsCount,
                onTap: () {},
              ),
              Icon(Icons.share, color: Colors.grey, size: 20),
            ],
          ),
        ],
      ),
    );
  }
}

class _PostStat extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final int? count;
  final VoidCallback onTap;

  const _PostStat({
    required this.icon,
    this.count,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 18, color: iconColor ?? Colors.grey),
          SizedBox(width: 10),
          Text(
            '${count ?? 0}',
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
