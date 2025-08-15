import 'package:equatable/equatable.dart';

abstract class SummaryEvent extends Equatable {
  const SummaryEvent();
  @override
  List<Object> get props => [];
}

class FetchMainbulletSummary extends SummaryEvent {
  final String postId;
  const FetchMainbulletSummary(this.postId);
  @override
  List<Object> get props => [postId];
}

class FetchClustersSummary extends SummaryEvent {
  final String postId;
  final List<String> listcluster;
  const FetchClustersSummary(this.postId, this.listcluster);
  @override
  List<Object> get props => [postId, listcluster];
}
