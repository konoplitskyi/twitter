part of 'create_post_bloc.dart';

sealed class CreatePostEvent extends Equatable {
  const CreatePostEvent();

  @override
  List<Object> get props => [];
}

class CreatePostRequested extends CreatePostEvent {
  final String username;
  final String content;
  final String userId;
  final String? imageUrl;

  const CreatePostRequested({
    required this.username,
    required this.content,
    required this.userId,
    required this.imageUrl,
  });
}
