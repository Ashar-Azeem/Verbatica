import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'votes_restrictor_event.dart';
part 'votes_restrictor_state.dart';

class VotesRestrictorBloc
    extends Bloc<VotesRestrictorEvent, VotesRestrictorState> {
  VotesRestrictorBloc() : super(VotesRestrictorState()) {
    on<RegisterVote>(registerVote);
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
}
