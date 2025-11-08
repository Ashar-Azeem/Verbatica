import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'votes_restrictor_event.dart';
part 'votes_restrictor_state.dart';

class VotesRestrictorBloc
    extends Bloc<VotesRestrictorEvent, VotesRestrictorState> {
  VotesRestrictorBloc() : super(VotesRestrictorState()) {
    on<RegisterVote>(registerVote);
    on<RegisterVoteOnComment>(registerVoteOnComment);
  }

  registerVote(RegisterVote event, Emitter<VotesRestrictorState> emit) {
    Map<String, int> count = Map.from(state.votesData);
    Map<String, bool> isAllowed = Map.from(state.canVote);
    count[event.postId] = (count[event.postId] ?? 0) + 1;
    if (count[event.postId]! > 3) {
      isAllowed[event.postId] = false;
    }

    emit(state.copyWith(count, isAllowed));
  }

  registerVoteOnComment(
    RegisterVoteOnComment event,
    Emitter<VotesRestrictorState> emit,
  ) {
    Map<String, int> count = Map.from(state.votesData);
    Map<String, bool> isAllowed = Map.from(state.canVote);
    count[event.commentId] = (count[event.commentId] ?? 0) + 1;
    if (count[event.commentId]! > 3) {
      isAllowed[event.commentId] = false;
    }

    emit(state.copyWith(count, isAllowed));
  }
}
