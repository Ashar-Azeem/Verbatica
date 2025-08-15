import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbatica/BLOC/comments_cluster/comment_cluster_bloc.dart';
import 'package:verbatica/UI_Components/singlecomment.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/Analysis%20Views/chartanalytics.dart';
import 'package:verbatica/model/comment.dart';

class Clusterscreen extends StatefulWidget {
  const Clusterscreen({
    required this.postid,
    required this.clusters,
    super.key,
  });
  final String postid;
  final List<String> clusters;
  @override
  State<Clusterscreen> createState() => _ClusterscreenState();
}

class _ClusterscreenState extends State<Clusterscreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    context.read<CommentClusterBloc>().add(
      LoadInitialComments(clusterId: 'ssds'),
    );
    _tabController = TabController(length: widget.clusters.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'Discussion Detail',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            letterSpacing: 0.3,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          ChartsAnalyticsScreen(clusters: widget.clusters),
                ),
              );
            },
            icon: Icon(
              Icons.bar_chart,
              size: 22,
              color: Theme.of(context).iconTheme.color,
            ),
            tooltip: 'View Analytics',
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [_buildTabBar(), Expanded(child: _buildCommentsList())],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Theme.of(context).cardColor,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        dividerColor: Theme.of(context).dividerColor,
        indicatorColor: Theme.of(context).colorScheme.primary,
        indicatorWeight: 3,
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: Theme.of(context).colorScheme.secondary,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        tabs:
            widget.clusters
                .map(
                  (cluster) => Tab(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(cluster),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '13', //we will write logic of number of comments for each cluster later , for dummy here 13 is written
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }

  Widget _buildCommentsList() {
    return BlocBuilder<CommentClusterBloc, CommentClusterState>(
      builder: (context, state) {
        return TabBarView(
          controller: _tabController,
          children:
              widget.clusters.map((cluster) {
                final clusterComments = state.comments;

                if (clusterComments.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: Theme.of(
                            context,
                          ).iconTheme.color?.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No comments in this cluster yet',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            Icons.add_comment,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          label: Text(
                            'Add First Comment',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Scrollbar(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(
                      left: 12,
                      right: 12,
                      top: 16,
                      bottom: 80,
                    ),
                    itemCount: clusterComments.length,
                    itemBuilder: (context, index) {
                      final comment = clusterComments[index];
                      Comment? parentComment;

                      if (comment.parentId != null) {
                        try {
                          parentComment = clusterComments.firstWhere(
                            (c) => c.id == comment.parentId,
                          );
                        } catch (e) {
                          parentComment = null;
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SingleCommentUI(
                          comment: comment,
                          parentComment: parentComment,
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
        );
      },
    );
  }
}
