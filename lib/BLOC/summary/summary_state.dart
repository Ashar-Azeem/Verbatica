import 'package:equatable/equatable.dart';

sealed class SummaryState extends Equatable {
  final List<String> summaryOfCluster;
  final List<String> bulletPoints;

  const SummaryState(this.summaryOfCluster, [this.bulletPoints = const []]);

  @override
  List<Object> get props => [summaryOfCluster, bulletPoints];
}

class SummaryInitial extends SummaryState {
  SummaryInitial() : super([], []);
}

class SummaryLoading extends SummaryState {
  SummaryLoading() : super([], []);
}

class SummaryLoaded extends SummaryState {
  SummaryLoaded(List<String> bulletPoints) : super([], bulletPoints);
}

class SummaryError extends SummaryState {
  final String message;
  SummaryError(this.message) : super([]);

  @override
  List<Object> get props => [message, ...super.props];
}

class ClusterDetailsLoading extends SummaryState {
  ClusterDetailsLoading() : super([]);
}

class ClusterDetailsLoaded extends SummaryState {
  final List<String> details;

  ClusterDetailsLoaded(this.details) : super(details);

  @override
  List<Object> get props => [details, ...super.props];
}
