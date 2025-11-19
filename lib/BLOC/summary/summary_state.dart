import 'package:equatable/equatable.dart';

class SummaryState extends Equatable {
  final List<String>? summaryOfCluster;
  final List<String>? bulletPoints;
  final bool isLoading;

  const SummaryState({
    this.summaryOfCluster,
    this.isLoading = true,
    this.bulletPoints,
  });
  SummaryState copyWith({
    List<String>? bulletPoints,
    List<String>? summaryOfCluster,
    bool? isLoading,
  }) {
    return SummaryState(
      summaryOfCluster: summaryOfCluster ?? this.summaryOfCluster,
      bulletPoints: bulletPoints ?? this.bulletPoints,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [summaryOfCluster, bulletPoints, isLoading];
}
