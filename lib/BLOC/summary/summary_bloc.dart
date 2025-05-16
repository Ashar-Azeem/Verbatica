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

      // Generate 20 dummy bullet points
      final bulletPoints = List<String>.generate(
        20,
        (index) =>
            "Bullet point ${index + 1}: Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      );

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
                    "Detailed summary for ${cluster.title}:\n\n"
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                    "Nullam euismod, nisl eget aliquam ultricies, nunc nisl "
                    "aliquet nunc, quis aliquam nisl nunc eu nisl. "
                    "Nullam euismod, nisl eget aliquam ultricies, nunc nisl "
                    "aliquet nunc, quis aliquam nisl nunc eu nisl. "
                    "This cluster contains important information about ${cluster.title}.",
              )
              .toList();

      emit(ClusterDetailsLoaded(clusterSummaries));
    } catch (e) {
      emit(SummaryError(e.toString()));
    }
  }
}
