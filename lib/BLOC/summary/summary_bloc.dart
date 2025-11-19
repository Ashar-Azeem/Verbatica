import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbatica/BLOC/summary/summary_event.dart';
import 'package:verbatica/BLOC/summary/summary_state.dart';
import 'package:verbatica/Services/API_Service.dart';
import 'package:verbatica/model/summary.dart';

class SummaryBloc extends Bloc<SummaryEvent, SummaryState> {
  final String postId;
  final List<String>? clusters;
  SummaryBloc({required this.postId, required this.clusters})
    : super(SummaryState()) {
    on<FetchSummary>(_onFetchSummary);
    add(FetchSummary());
  }

  List<String> parseSummary(String text) {
    return text
        .split('*') // split by the bullet marker
        .map((line) => line.trim()) // remove extra spaces
        .where((line) => line.isNotEmpty) // ignore empty lines
        .toList();
  }

  Future<void> _onFetchSummary(
    FetchSummary event,
    Emitter<SummaryState> emit,
  ) async {
    try {
      Summary? summary = await ApiService().fetchSummary(postId);
      if (summary == null) {
        emit(state.copyWith(isLoading: false));
      } else {
        if (summary.type == 'polarized') {
          List<String> summaries = [];

          if (clusters != null && clusters!.isNotEmpty) {
            for (final cluster in clusters!) {
              final matchingSummary = summary.summaries.firstWhere(
                (s) => s.narrative == cluster,
                orElse: () => SummaryItem(narrative: cluster, summary: ""),
              );
              summaries.add(matchingSummary.summary ?? "");
            }
          }

          emit(state.copyWith(isLoading: false, summaryOfCluster: summaries));
        } else {
          String summaryText = summary.summaries.first.summary ?? "";
          List<String> summaryInBulletPoints = parseSummary(summaryText);
          emit(
            state.copyWith(
              isLoading: false,
              bulletPoints: summaryInBulletPoints,
            ),
          );
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
