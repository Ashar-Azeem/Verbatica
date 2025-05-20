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
        title: const Text(
          'Summary',
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(
          255,
          67,
          118,
          138,
        ).withOpacity(0.6),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.05),
              Colors.transparent,
            ],
          ),
        ),
        child: BlocBuilder<SummaryBloc, SummaryState>(
          builder: (context, state) {
            // Handle error state
            if (state is SummaryError) {
              return _buildErrorState(context, state.message);
            }

            // Handle loading state
            if (state is SummaryLoading || state is ClusterDetailsLoading) {
              return _buildLoadingState(context);
            }

            // Handle loaded states
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: _buildMainContent(context, state),
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              if (!showClusters) {
                context.read<SummaryBloc>().add(FetchMainbulletSummary(postId));
              } else if (clusters != null && clusters!.isNotEmpty) {
                context.read<SummaryBloc>().add(
                  FetchClustersSummary(postId, clusters!),
                );
              }
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            'Generating summary...',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, SummaryState state) {
    if (state is SummaryLoaded) {
      // Ensure bulletPoints is not empty
      if (state.bulletPoints.isEmpty) {
        return _buildEmptyContent('No bullet points available');
      }
      return _buildBulletPointsContent(context, state.bulletPoints);
    } else if (state is ClusterDetailsLoaded) {
      // Ensure we have clusters and summaries
      if (clusters == null ||
          clusters!.isEmpty ||
          state.summaryOfCluster.isEmpty) {
        return _buildEmptyContent('No cluster summaries available');
      }

      // Use TabView for cluster summaries instead of the previous layout
      return _buildClusterTabView(context, clusters!, state.summaryOfCluster);
    }

    return _buildEmptyContent('No content available');
  }

  Widget _buildEmptyContent(String message) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            children: [
              const Icon(Icons.info_outline, size: 48, color: Colors.blue),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPointsContent(
    BuildContext context,
    List<String> bulletPoints,
  ) {
    return SingleChildScrollView(
      child: Card(
        elevation: 4,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.lightbulb_outline,
                      size: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Key Points',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1, thickness: 1, color: Colors.white12),
              ),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: bulletPoints.length,
                separatorBuilder:
                    (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6, right: 12),
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          bulletPoints[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // New method to build the Tab View for clusters
  Widget _buildClusterTabView(
    BuildContext context,
    List<Cluster> clusters,
    List<String> summaries,
  ) {
    return DefaultTabController(
      length: clusters.length,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75, // Set a fixed height
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Shrink wrap content
          children: [
            // Tab Bar with cluster titles
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                isScrollable: true,
                labelColor: Theme.of(context).colorScheme.onPrimary,
                unselectedLabelColor: Theme.of(
                  context,
                ).colorScheme.onSurface.withOpacity(0.6),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
                indicator: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                tabs:
                    clusters
                        .map(
                          (cluster) => Tab(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(cluster.title),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),

            // Tab content area - using Flexible instead of Expanded
            Flexible(
              child: TabBarView(
                children: List.generate(
                  clusters.length,
                  (index) => _buildClusterContentTab(
                    context,
                    clusters[index],
                    summaries[index],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Display individual cluster content within each tab
  Widget _buildClusterContentTab(
    BuildContext context,
    Cluster cluster,
    String summary,
  ) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(2), // Add small margin
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Shrink wrap content
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.category_outlined,
                      size: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      cluster.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                        letterSpacing: 0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1, thickness: 1, color: Colors.white12),
              ),
              Text(
                summary,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
