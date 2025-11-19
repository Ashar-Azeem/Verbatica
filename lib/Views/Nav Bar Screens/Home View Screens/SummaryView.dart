import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/summary/summary_bloc.dart';
import 'package:verbatica/BLOC/summary/summary_state.dart';

class SummaryScreen extends StatelessWidget {
  final bool showClusters;
  final List<String>? clusters;
  final String postId;

  const SummaryScreen({
    super.key,
    required this.showClusters,
    required this.postId,
    this.clusters,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SummaryBloc(postId: postId, clusters: clusters),
      child: Scaffold(
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

            if (state.isLoading) {
              return Center(
                child: LoadingAnimationWidget.dotsTriangle(
                  color: Theme.of(context).colorScheme.primary,
                  size: 13.w,
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: _buildMainContent(context, state),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, SummaryState state) {
    if (showClusters) {
      // Use TabView for cluster summaries instead of the previous layout
      return _buildClusterTabView(context, clusters!, state.summaryOfCluster);
    } else {
      return _buildBulletPointsContent(context, state.bulletPoints);
    }
  }

  Widget _buildBulletPointsContent(
    BuildContext context,
    List<String>? bulletPoints,
  ) {
    return SingleChildScrollView(
      child:
          bulletPoints == null
              ? Padding(
                padding: EdgeInsets.only(top: 30.h),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.summarize,
                        size: 64,
                        color: Theme.of(
                          context,
                        ).iconTheme.color?.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No summary available yet!',
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 3.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                Theme.of(
                                  context,
                                ).textTheme.headlineSmall?.color ??
                                Theme.of(context).colorScheme.onSurface,
                            fontSize: 20,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: Theme.of(context).dividerColor.withOpacity(0.12),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 4.w),
                    child: ListView.separated(
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
                                      Theme.of(
                                        context,
                                      ).textTheme.bodyLarge?.color ??
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
                  ),
                ],
              ),
    );
  }

  // New method to build the Tab View for clusters
  Widget _buildClusterTabView(
    BuildContext context,
    List<String> clusters,
    List<String>? summaries,
  ) {
    return DefaultTabController(
      length: clusters.length,
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Shrink wrap content
          children: [
            // Tab Bar with cluster titles
            TabBar(
              tabAlignment: TabAlignment.center,
              dividerColor: Theme.of(context).dividerColor,
              isScrollable: true,
              labelColor: Theme.of(context).colorScheme.primary,
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
                            child: Text(cluster),
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
                    summaries == null || summaries.length - 1 < index
                        ? ""
                        : summaries[index],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClusterContentTab(
    BuildContext context,
    String cluster,
    String summary,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 2.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Shrink wrap content
          children: [
            summary.isEmpty
                ? Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.summarize,
                          size: 64,
                          color: Theme.of(
                            context,
                          ).iconTheme.color?.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No summary available yet!',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                : Card(
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: AnimatedTextKit(
                      isRepeatingAnimation: false,
                      animatedTexts: [
                        TypewriterAnimatedText(
                          speed: Duration(milliseconds: 10),
                          summary,
                          textStyle: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyLarge?.color ??
                                Theme.of(context).colorScheme.onSurface,
                            fontSize: 16,
                            height: 1.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
