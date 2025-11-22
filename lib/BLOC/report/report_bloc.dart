// BLoC
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbatica/BLOC/report/report_event.dart';
import 'package:verbatica/BLOC/report/report_state.dart';
import 'package:verbatica/model/report.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  // Note: This is just a placeholder and would normally contain a repository
  // The implementation of this BLoC is not part of the task

  ReportBloc() : super(ReportInitial()) {
    on<FetchUserReports>(_onFetchUserReports);
  }

  Future<void> _onFetchUserReports(
    FetchUserReports event,
    Emitter<ReportState> emit,
  ) async {
    try {
      // Emit loading state
      emit(ReportLoading());

      // Simulate network delay of 2 seconds
      await Future.delayed(const Duration(seconds: 2));

      // Create dummy report data
      final dummyReports = [
        Report(
          reportId: '1001',
          reporterUserId: event.userId,
          isPostReport: true,
          isCommentReport: false,
          isUserReport: false,
          postId: 'post123',
          commentId: null,
          reportedUserId: null,
          reportContent:
              'This post contains misleading information about health supplements that could be harmful to users.',
          reportTime: DateTime.now().subtract(const Duration(days: 2)),

          reportStatus: 'under_review',
          adminFeedback: null,
        ),
        Report(
          reportId: '1002',
          reporterUserId: event.userId,
          isPostReport: false,
          isCommentReport: true,
          isUserReport: false,
          postId: null,
          commentId: 'comment456',
          reportedUserId: null,
          reportContent:
              'This comment contains hate speech targeting a specific community.',
          reportTime: DateTime.now().subtract(const Duration(days: 5)),

          reportStatus: 'resolved',
          adminFeedback:
              'Thank you for bringing this to our attention. The comment has been removed and we have issued a warning to the user.',
        ),
        Report(
          reportId: '1003',
          reporterUserId: event.userId,
          isPostReport: false,
          isCommentReport: false,
          isUserReport: true,
          postId: null,
          commentId: null,
          reportedUserId: 'user789',
          reportContent:
              'This user has been repeatedly spamming promotional content across multiple threads.',
          reportTime: DateTime.now().subtract(const Duration(days: 10)),

          reportStatus: 'resolved',
          adminFeedback:
              'Weve reviewed the user activity and have suspended the account for violating our anti-spam policy. Thank you for helping keep our community clean.',
        ),
        Report(
          reportId: '1004',
          reporterUserId: event.userId,
          isPostReport: true,
          isCommentReport: false,
          isUserReport: false,
          postId: 'post234',
          commentId: null,
          reportedUserId: null,
          reportContent:
              'This post contains copyrighted images that I own the rights to. Please remove it.',
          reportTime: DateTime.now().subtract(const Duration(days: 7)),

          reportStatus: 'rejected',
          adminFeedback:
              'Our team has reviewed your claim but could not verify copyright ownership based on the information provided. Please submit additional documentation to support your claim.',
        ),
        Report(
          reportId: '1005',
          reporterUserId: event.userId,
          isPostReport: false,
          isCommentReport: true,
          isUserReport: false,
          postId: null,
          commentId: 'comment789',
          reportedUserId: null,
          reportContent:
              'This comment reveals personal information about me without my consent.',
          reportTime: DateTime.now().subtract(const Duration(hours: 12)),

          reportStatus: 'pending',
          adminFeedback: null,
        ),
      ];

      // Sort reports by most recent first
      dummyReports.sort((a, b) => b.reportTime.compareTo(a.reportTime));

      // Emit success state with reports
      emit(ReportLoaded(dummyReports));
    } catch (e) {
      // Emit error state if something goes wrong
      emit(ReportError('Failed to load reports: ${e.toString()}'));
    }
  }
}
