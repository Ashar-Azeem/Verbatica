import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:verbatica/DummyData/comments.dart';
import 'package:verbatica/model/comment.dart';

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  CommentsBloc() : super(CommentsState()) {
    on<LoadInitialComments>(loadInitialComments);
    on<LoadMoreComments>(loadMoreComments);
    on<UpVoteComment>(upVoteComment);
    on<DownVoteComment>(downVoteComment);
    on<AddComment>(addComment);
  }

  loadInitialComments(
    LoadInitialComments event,
    Emitter<CommentsState> emit,
  ) async {
    await Future.delayed(Duration(seconds: 1));
    emit(state.copyWith(initialLoader: false, comments: dummyComments));
  }

  loadMoreComments(LoadMoreComments event, Emitter<CommentsState> emit) {}
  upVoteComment(UpVoteComment event, Emitter<CommentsState> emit) {}
  downVoteComment(DownVoteComment event, Emitter<CommentsState> emit) {}
  addComment(AddComment event, Emitter<CommentsState> emit) {}
}
