import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter/core/utils.dart';
import 'package:twitter/features/auth/domain/services/user_session_service.dart';
import 'package:twitter/features/feed/domain/entities/post_entity.dart';
import 'package:twitter/features/feed/domain/usecases/fetch_post_use_case.dart';
import 'package:twitter/features/feed/domain/usecases/like_post_use_case.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FetchPostUseCase fetchPostUseCase;
  LikePostUseCase likePostUseCase;
  UserSessionService userSessionService;

  FeedBloc({
    required this.fetchPostUseCase,
    required this.likePostUseCase,
    required this.userSessionService,
  }) : super(FeedInitial()) {
    on<FetchPostsRequested>(_fetchPostRequested);
    on<LikePostRequested>(_onLikePostRequested);
  }

  Future<void> _fetchPostRequested(
    FetchPostsRequested event,
    Emitter<FeedState> emit,
  ) async {
    emit(FeedLoading());
    try {
      final session = await userSessionService.getUserSession();
      final posts = await fetchPostUseCase.call(currentUserId: session?.id);
      emit(FeedLoaded(posts: posts));
    } on Exception catch (e) {
      emit(FeedFailure(message: formatError(e)));
    }
  }

  Future<void> _onLikePostRequested(
    LikePostRequested event,
    Emitter<FeedState> emit,
  ) async {
    try {
      await likePostUseCase.call(postId: event.postId, userId: event.userId);
      add(FetchPostsRequested());
    } on Exception catch (e) {
      emit(FeedFailure(message: formatError(e)));
    }
  }
}
