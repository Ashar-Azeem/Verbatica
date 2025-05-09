// BLoC
import 'package:bloc/bloc.dart';
import 'package:verbatica/BLOC/postsubmit/postsubmit_event.dart';
import 'package:verbatica/BLOC/postsubmit/postsubmit_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(const PostState()) {
    on<SubmitPostEvent>(_submitPost);
  }

  Future<void> _submitPost(
    SubmitPostEvent event,
    Emitter<PostState> emit,
  ) async {}
}
