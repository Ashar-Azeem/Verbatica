import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbatica/BLOC/summary/summary_event.dart';
import 'package:verbatica/BLOC/summary/summary_state.dart';

class SummaryBloc extends Bloc<SummaryEvent, SummaryState> {
  SummaryBloc() : super(SummaryInitial()) {
    on<FetchMainbulletSummary>(_onFetchSummary);
    on<FetchClustersSummary>(_onFetchClusterDetails);
  }

  Future<void> _onFetchSummary(
    FetchMainbulletSummary event,
    Emitter<SummaryState> emit,
  ) async {
    emit(SummaryLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));

      final bulletPoints = List<String>.generate(20, (index) {
        final phrases = [
          "Fresh perspective on a recurring theme.",
          "Noteworthy trend with long-term impact.",
          "Small detail, big implications.",
          "Challenging the status quo, gently.",
          "Insight hiding in plain sight.",
          "A subtle nudge toward innovation.",
          "Reframing the narrative, one step at a time.",
          "Signals worth paying attention to.",
          "Disruption, but make it elegant.",
          "Patterns emerging from the noise.",
        ];
        final phrase = phrases[index % phrases.length];
        return phrase;
      });

      emit(SummaryLoaded(bulletPoints));
    } catch (e) {
      emit(SummaryError(e.toString()));
    }
  }

  Future<void> _onFetchClusterDetails(
    FetchClustersSummary event,
    Emitter<SummaryState> emit,
  ) async {
    emit(ClusterDetailsLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));

      // Generate one long paragraph for each cluster
      final clusterSummaries =
          event.listcluster
              .map(
                (cluster) =>
                    "📌 Summary for \"{cluster\"\n\n"
                    "Dive into the key insights and noteworthy highlights of $cluster. "
                    "This section uncovers essential patterns, emerging trends, and contextual relevance. "
                    "From subtle details to major breakthroughs, $cluster offers a comprehensive view "
                    "that helps connect the dots and spark new ideas.\n\n"
                    "Stay curious — there's more than meets the eye in $cluster.",
              )
              .toList();

      emit(ClusterDetailsLoaded(clusterSummaries));
    } catch (e) {
      emit(SummaryError(e.toString()));
    }
  }
}
