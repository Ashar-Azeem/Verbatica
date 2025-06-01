import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/Search%20Bloc/search_bloc.dart';
import 'package:verbatica/UI_Components/Search%20Componenets/SearchedPostUI.dart';
import 'package:verbatica/UI_Components/Search%20Componenets/SearchedUserUI.dart';
import 'package:verbatica/Utilities/Color.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> with TickerProviderStateMixin {
  late TabController _tabController;
  late SearchController searchController;
  late SearchBloc searchBloc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    searchController = SearchController();
    searchBloc = context.read<SearchBloc>();
  }

  @override
  void dispose() {
    _tabController.dispose();
    searchController.dispose();
    searchBloc.add(Reset());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(2.w),
            child: Column(
              children: [
                SearchAnchor(
                  searchController: searchController,
                  builder: (context, controller) {
                    return Center(
                      child: SearchBar(
                        onTapOutside: (event) {},
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            if (_tabController.index == 0) {
                              context.read<SearchBloc>().add(
                                SearchUsers(userName: value),
                              );
                            } else {
                              context.read<SearchBloc>().add(
                                SearchPosts(postTitle: value),
                              );
                            }
                          } else {
                            context.read<SearchBloc>().add(Reset());
                          }
                        },
                        constraints: BoxConstraints(
                          maxHeight: 5.h,
                          maxWidth: 90.w,
                          minHeight: 5.h,
                          minWidth: 90.w,
                        ),
                        hintText: 'Search',
                        hintStyle: WidgetStatePropertyAll<TextStyle>(
                          TextStyle(
                            color: textTheme.bodyMedium?.color?.withOpacity(
                              0.6,
                            ),
                          ),
                        ),
                        textStyle: WidgetStatePropertyAll<TextStyle>(
                          TextStyle(color: textTheme.bodyLarge?.color),
                        ),
                        backgroundColor: WidgetStatePropertyAll<Color>(
                          colorScheme.surfaceVariant,
                        ),
                        controller: controller,
                        padding: const WidgetStatePropertyAll<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        onChanged: (value) {
                          if (_tabController.index == 0) {
                            context.read<SearchBloc>().add(
                              SearchUsers(userName: value),
                            );
                          } else {
                            context.read<SearchBloc>().add(
                              SearchPosts(postTitle: value),
                            );
                          }
                        },
                        leading: Icon(
                          Icons.search,
                          color: textTheme.bodyMedium?.color?.withOpacity(0.7),
                        ),
                      ),
                    );
                  },
                  suggestionsBuilder: (context, controller) {
                    return [];
                  },
                ),
                TabBar(
                  onTap: (value) {
                    if (searchController.text.trim().isNotEmpty) {
                      if (value == 0) {
                        context.read<SearchBloc>().add(
                          SearchUsers(userName: searchController.text),
                        );
                      } else {
                        context.read<SearchBloc>().add(
                          SearchPosts(postTitle: searchController.text),
                        );
                      }
                    }
                  },
                  controller: _tabController,
                  labelColor: colorScheme.primary,
                  unselectedLabelColor: textTheme.bodyMedium?.color
                      ?.withOpacity(0.7),
                  indicatorColor: colorScheme.primary,
                  dividerColor: colorScheme.outline.withOpacity(0.2),
                  tabs: [Tab(text: "Users"), Tab(text: "Discussions")],
                ),
                Expanded(
                  child: BlocBuilder<SearchBloc, SearchState>(
                    buildWhen: (previous, current) {
                      return previous.loadingPosts != current.loadingPosts ||
                          previous.loadingUsers != current.loadingUsers ||
                          previous.posts != current.posts ||
                          previous.users != current.users;
                    },
                    builder: (context, state) {
                      return TabBarView(
                        controller: _tabController,
                        children: [
                          // Users Tab
                          state.loadingUsers
                              ? Center(
                                child: LoadingAnimationWidget.dotsTriangle(
                                  color: colorScheme.primary,
                                  size: 10.w,
                                ),
                              )
                              : state.users.isEmpty
                              ? Center(
                                child: Text(
                                  "No Users Found",
                                  style: TextStyle(
                                    color: textTheme.bodyLarge?.color,
                                    fontSize: textTheme.bodyLarge?.fontSize,
                                  ),
                                ),
                              )
                              : ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                padding: EdgeInsets.only(top: 8),
                                addRepaintBoundaries: true,
                                cacheExtent: 500,
                                itemCount: state.users.length,
                                itemBuilder: (context, index) {
                                  return SearchedUser(user: state.users[index]);
                                },
                              ),

                          // Posts Tab
                          state.loadingPosts
                              ? Center(
                                child: LoadingAnimationWidget.dotsTriangle(
                                  color: colorScheme.primary,
                                  size: 10.w,
                                ),
                              )
                              : state.posts.isEmpty
                              ? Center(
                                child: Text(
                                  "No Posts Found",
                                  style: TextStyle(
                                    color: textTheme.bodyLarge?.color,
                                    fontSize: textTheme.bodyLarge?.fontSize,
                                  ),
                                ),
                              )
                              : ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                padding: EdgeInsets.only(top: 8),
                                addRepaintBoundaries: true,
                                cacheExtent: 500,
                                itemCount: state.posts.length,
                                itemBuilder: (context, index) {
                                  return SearchedPost(
                                    post: state.posts[index],
                                    index: index,
                                    onFullView: false,
                                  );
                                },
                              ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
