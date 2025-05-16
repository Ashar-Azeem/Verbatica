import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbatica/BLOC/summary/summary_bloc.dart';
import 'package:verbatica/BLOC/summary/summary_event.dart';
import 'package:verbatica/BLOC/summary/summary_state.dart';
import 'package:verbatica/model/Post.dart';

class SummaryScreen extends StatelessWidget {
  final bool showClusters;
  final List<Cluster>? clusters;
  final String postId;

  const SummaryScreen({
    Key? key,
    required this.showClusters,
    required this.postId,
    this.clusters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Trigger the appropriate event based on showClusters
    if (!showClusters) {
      context.read<SummaryBloc>().add(FetchMainbulletSummary(postId));
    } else if (clusters != null && clusters!.isNotEmpty) {
      context.read<SummaryBloc>().add(FetchClustersSummary(postId, clusters!));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary'),
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<SummaryBloc, SummaryState>(
        builder: (context, state) {
          // Handle error state
          if (state is SummaryError) {
            return Center(child: Text(state.message));
          }

          // Handle loading state
          if (state is SummaryLoading || state is ClusterDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle loaded states
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildMainContent(context, state)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, SummaryState state) {
    if (state is SummaryLoaded) {
      // Ensure bulletPoints is not empty
      if (state.bulletPoints.isEmpty) {
        return _buildEmptyContent('No bullet points available');
      }
      return _buildBulletPointsContent(state.bulletPoints);
    } else if (state is ClusterDetailsLoaded) {
      // Ensure we have clusters and summaries
      if (clusters == null ||
          clusters!.isEmpty ||
          state.summaryOfCluster.isEmpty) {
        return _buildEmptyContent('No cluster summaries available');
      }
      return _buildClusterContent(clusters!, state.summaryOfCluster);
    }

    return _buildEmptyContent('No content available');
  }

  Widget _buildEmptyContent(String message) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(message, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildBulletPointsContent(List<String> bulletPoints) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Key Points',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children:
                  bulletPoints
                      .map(
                        (point) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 4, right: 12),
                                child: Icon(
                                  Icons.circle,
                                  size: 10,
                                  color: Colors.blue,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  point,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClusterContent(List<Cluster> clusters, List<String> summaries) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cluster Summaries',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(
              clusters.length,
              (index) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clusters[index].title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    summaries[index],
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  if (index != clusters.length - 1)
                    const Divider(height: 24, color: Colors.white30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
