import 'package:equatable/equatable.dart';

// Events
abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object> get props => [];
}

class FetchUserReports extends ReportEvent {
  final String userId;

  const FetchUserReports(this.userId);

  @override
  List<Object> get props => [userId];
}
