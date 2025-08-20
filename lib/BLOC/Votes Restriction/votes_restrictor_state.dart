part of 'votes_restrictor_bloc.dart';

class VotesRestrictorState extends Equatable {
  final Map<String, int> votesData;
  final Map<String, bool> canVote;

  const VotesRestrictorState({
    this.votesData = const {},
    this.canVote = const {},
  });
  VotesRestrictorState copyWith(
    Map<String, int>? votesData,
    Map<String, bool>? canVote,
  ) {
    return VotesRestrictorState(
      votesData: votesData ?? this.votesData,
      canVote: canVote ?? this.canVote,
    );
  }

  @override
  List<Object> get props => [votesData, canVote];
}
