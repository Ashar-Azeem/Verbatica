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
    super.key,
    required this.showClusters,
    required this.postId,
    this.clusters,
  });

  @override
  Widget build(BuildContext context) {
    // Trigger the appropriate event based on showClusters
    if (!showClusters) {
      context.read<SummaryBloc>().add(FetchMainbulletSummary(postId));
    } else if (clusters != null && clusters!.isNotEmpty) {
      context.read<SummaryBloc>().add(FetchClustersSummary(postId, clusters!));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Summary',
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: BlocBuilder<SummaryBloc, SummaryState>(
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
              color:
                  Theme.of(context).textTheme.bodyLarge?.color ??
                  Theme.of(context).colorScheme.onSurface,
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
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
          CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            'Generating summary...',
            style: TextStyle(
              fontSize: 16,
              color:
                  Theme.of(
                    context,
                  ).textTheme.bodyLarge?.color?.withOpacity(0.7) ??
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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
        return _buildEmptyContent(context, 'No bullet points available');
      }
      return _buildBulletPointsContent(context, state.bulletPoints);
    } else if (state is ClusterDetailsLoaded) {
      // Ensure we have clusters and summaries
      if (clusters == null ||
          clusters!.isEmpty ||
          state.summaryOfCluster.isEmpty) {
        return _buildEmptyContent(context, 'No cluster summaries available');
      }

      // Use TabView for cluster summaries instead of the previous layout
      return _buildClusterTabView(context, clusters!, state.summaryOfCluster);
    }

    return _buildEmptyContent(context, 'No content available');
  }

  Widget _buildEmptyContent(BuildContext context, String message) {
    return Card(
      elevation: 3,
      shadowColor: Theme.of(context).shadowColor.withOpacity(0.26),
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.info_outline,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: TextStyle(
                  color:
                      Theme.of(
                        context,
                      ).textTheme.bodyLarge?.color?.withOpacity(0.7) ??
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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
        shadowColor: Theme.of(context).shadowColor.withOpacity(0.26),
        color: Theme.of(context).cardColor,
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
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.lightbulb_outline,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Key Points',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          Theme.of(context).textTheme.headlineSmall?.color ??
                          Theme.of(context).colorScheme.onSurface,
                      fontSize: 20,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: Theme.of(context).dividerColor.withOpacity(0.12),
                ),
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
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          bulletPoints[index],
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyLarge?.color ??
                                Theme.of(context).colorScheme.onSurface,
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
            TabBar(
              dividerColor: Theme.of(context).dividerColor,
              isScrollable: true,
              labelColor: Theme.of(context).colorScheme.onPrimary,
              unselectedLabelColor:
                  Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color?.withOpacity(0.6) ??
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),

              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              tabs:
                  clusters
                      .map(
                        (cluster) => Tab(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(cluster.title),
                          ),
                        ),
                      )
                      .toList(),
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
      shadowColor: Theme.of(context).shadowColor.withOpacity(0.26),
      color: Theme.of(context).cardColor,
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
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.category_outlined,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      cluster.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            Theme.of(context).textTheme.headlineSmall?.color ??
                            Theme.of(context).colorScheme.onSurface,
                        fontSize: 20,
                        letterSpacing: 0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: Theme.of(context).dividerColor.withOpacity(0.12),
                ),
              ),
              Text(
                summary,
                style: TextStyle(
                  color:
                      Theme.of(context).textTheme.bodyLarge?.color ??
                      Theme.of(context).colorScheme.onSurface,
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
