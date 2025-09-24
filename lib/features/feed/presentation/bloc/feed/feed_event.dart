part of 'feed_bloc.dart';

sealed class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object> get props => [];
}

class FetchPostsRequested extends FeedEvent {}

class LikePostRequested extends FeedEvent {
  final String postId;
  final String userId;

  const LikePostRequested({required this.postId, required this.userId});
}
