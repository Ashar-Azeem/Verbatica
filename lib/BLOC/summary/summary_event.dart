import 'package:equatable/equatable.dart';
import 'package:verbatica/model/Post.dart';

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
  final List<Cluster> listcluster;
  const FetchClustersSummary(this.postId, this.listcluster);
  @override
  List<Object> get props => [postId, listcluster];
}
