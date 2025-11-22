// BLoC
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbatica/BLOC/report/report_event.dart';
import 'package:verbatica/BLOC/report/report_state.dart';
import 'package:verbatica/Services/API_Service.dart';
import 'package:verbatica/model/report.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc() : super(ReportInitial()) {
    on<FetchUserReports>(_onFetchUserReports);
  }

  Future<void> _onFetchUserReports(
    FetchUserReports event,
    Emitter<ReportState> emit,
  ) async {
    try {
      emit(ReportLoading());

      List<Report> reports = await ApiService().getReports(event.userId);

      emit(ReportLoaded(reports));
    } catch (e) {
      // Emit error state if something goes wrong
      emit(ReportError('Failed to load reports: ${e.toString()}'));
    }
  }
}
