import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter/core/utils.dart';
import 'package:twitter/features/feed/domain/usecases/create_post_use_case.dart';

part 'create_post_event.dart';
part 'create_post_state.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  CreatePostUseCase createPostUseCase;

  CreatePostBloc({required this.createPostUseCase})
    : super(CreatePostInitial()) {
    on<CreatePostRequested>(_createPostRequested);
  }

  Future<void> _createPostRequested(
    CreatePostRequested event,
    Emitter<CreatePostState> emit,
  ) async {
    emit(CreatePostLoading());
    try {
      await createPostUseCase.call(
        userId: event.userId,
        username: event.username,
        content: event.content,
        imageUrl: event.imageUrl,
      );
      emit(CreatePostSuccess());
    } on Exception catch (e) {
      emit(CreatePostFailure(message: formatError(e)));
    }
  }
}
