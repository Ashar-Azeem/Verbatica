import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbatica/BLOC/comments_cluster/comment_cluster_bloc.dart';
import 'package:verbatica/UI_Components/singlecomment.dart';

import 'package:verbatica/Views/chartanalytics.dart';
import 'package:verbatica/model/Post.dart';
import 'package:verbatica/model/comment.dart';

class Clusterscreen extends StatefulWidget {
  const Clusterscreen({
    required this.postid,
    required this.clusters,
    // Add comments parameter
    super.key,
  });
  final String postid;
  final List<Cluster> clusters;
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
      appBar: AppBar(
        title: Text('Discussion Detail'),
        backgroundColor: const Color.fromARGB(
          255,
          67,
          118,
          138,
        ).withOpacity(0.6),
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

            icon: const Icon(Icons.bar_chart, color: Colors.white),
          ),
        ],
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs:
              widget.clusters
                  .map((cluster) => Tab(text: cluster.title))
                  .toList(),
        ),
      ),
      body: BlocBuilder<CommentClusterBloc, CommentClusterState>(
        builder: (context, state) {
          return TabBarView(
            controller: _tabController,
            children:
                widget.clusters.map((cluster) {
                  final clusterComments = state.comments;

                  return ListView.builder(
                    padding: EdgeInsets.only(bottom: 80),
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
                          parentComment =
                              null; // Or handle missing parent differently
                        }
                      }
                      return SingleCommentUI(
                        comment: comment,
                        parentComment: parentComment,
                      );
                    },
                  );
                }).toList(),
          );
        },
      ),
    );
  }
}
