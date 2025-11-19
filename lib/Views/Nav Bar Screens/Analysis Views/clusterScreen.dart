import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/BLOC/comments_cluster/comment_cluster_bloc.dart';
import 'package:verbatica/UI_Components/Comment%20Componenets/clusterComments.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/Analysis%20Views/chartanalytics.dart';

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
  int previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.clusters.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => CommentClusterBloc(
            totalCluster: widget.clusters.length,
            clusterNames: widget.clusters,
            postId: widget.postid,
            userId: context.read<UserBloc>().state.user!.id,
          ),
      child: BlocBuilder<CommentClusterBloc, CommentClusterState>(
        builder: (context, state) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _tabController.addListener(() {
              if (!_tabController.indexIsChanging &&
                  previousIndex != _tabController.index) {
                previousIndex = _tabController.index;
                context.read<CommentClusterBloc>().add(
                  LoadOtherTabs(tabIndex: _tabController.index),
                );
              }
            });
          });
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
                            (context) => ChartsAnalyticsScreen(
                              postId: int.parse(widget.postid),
                              clusters: widget.clusters,
                            ),
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
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return BlocBuilder<CommentClusterBloc, CommentClusterState>(
      builder: (context, state) {
        return Container(
          color: Theme.of(context).cardColor,
          child: TabBar(
            tabAlignment: TabAlignment.center,
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
            onTap: (value) {
              previousIndex = value;
              context.read<CommentClusterBloc>().add(
                LoadOtherTabs(tabIndex: value),
              );
            },
            tabs:
                widget.clusters
                    .map(
                      (cluster) => Tab(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [Text(cluster)],
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        );
      },
    );
  }

  Widget _buildCommentsList() {
    return BlocBuilder<CommentClusterBloc, CommentClusterState>(
      builder: (context, state) {
        if (state.comments.isEmpty) {
          return Padding(
            padding: EdgeInsets.only(top: 40.h),
            child: Center(
              child: LoadingAnimationWidget.dotsTriangle(
                color: Theme.of(context).colorScheme.primary,
                size: 13.w,
              ),
            ),
          );
        }

        return TabBarView(
          controller: _tabController,

          children:
              widget.clusters.asMap().entries.map((entry) {
                final newIndex = entry.key;
                if (newIndex >= state.comments.length) {
                  // safety guard
                  return const SizedBox.shrink();
                }

                final CommentSectionOfEachTab clusterComments =
                    state.comments[newIndex];
                if (clusterComments.isLoading) {
                  return Center(
                    child: LoadingAnimationWidget.dotsTriangle(
                      color: Theme.of(context).colorScheme.primary,
                      size: 13.w,
                    ),
                  );
                } else if (clusterComments.comments.isEmpty) {
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
                      ],
                    ),
                  );
                }
                return Scrollbar(
                  child: ListView.builder(
                    key: PageStorageKey('cluster-$newIndex'),
                    padding: EdgeInsets.only(
                      left: 1.w,
                      right: 1.w,
                      top: 16,
                      bottom: 2.h,
                    ),
                    addAutomaticKeepAlives: true,
                    itemCount: state.comments[newIndex].comments.length,
                    itemBuilder: (context, index) {
                      ExpandableComments comment =
                          state.comments[newIndex].comments[index];
                      return Padding(
                        padding: EdgeInsets.only(top: 0.5.h),
                        child: GestureDetector(
                          onDoubleTap: () {
                            //Event to expand or contract the commment block
                            context.read<CommentClusterBloc>().add(
                              ToggleExpandOrCollapse(
                                tabIndex: newIndex,
                                listIndex: index,
                              ),
                            );
                          },
                          child: Card(
                            child: ClusterComments(
                              comment: comment.comment,
                              level: 1,
                              tabBarIndex: newIndex,
                              clusterIndex: index,
                              isExpand:
                                  state
                                      .comments[newIndex]
                                      .comments[index]
                                      .isExpand,
                              toggleFold: () {
                                context.read<CommentClusterBloc>().add(
                                  ToggleExpandOrCollapse(
                                    tabIndex: newIndex,
                                    listIndex: index,
                                  ),
                                );
                              },
                            ),
                          ),
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
