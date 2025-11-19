import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/Search%20Bloc/search_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/UI_Components/PostComponents/PostUI.dart';
import 'package:verbatica/UI_Components/Search%20Componenets/SearchedUserUI.dart';

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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
                                SearchPosts(
                                  postTitle: value,
                                  userId:
                                      context.read<UserBloc>().state.user!.id,
                                ),
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
                          isDarkMode
                              ? const Color(0xFF27343D)
                              : const Color.fromARGB(255, 247, 246, 246),
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
                              SearchPosts(
                                postTitle: value,
                                userId: context.read<UserBloc>().state.user!.id,
                              ),
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
                          SearchPosts(
                            postTitle: searchController.text,
                            userId: context.read<UserBloc>().state.user!.id,
                          ),
                        );
                      }
                    }
                  },
                  controller: _tabController,
                  labelColor: colorScheme.primary,
                  unselectedLabelColor: textTheme.bodyMedium?.color
                      ?.withOpacity(0.7),
                  indicatorColor: colorScheme.primary,
                  dividerColor: Theme.of(context).dividerColor,
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
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.people_alt_outlined,
                                      size: 64,
                                      color: Theme.of(
                                        context,
                                      ).iconTheme.color?.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No users found',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color
                                            ?.withOpacity(0.7),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
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
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.note_sharp,
                                      size: 64,
                                      color: Theme.of(
                                        context,
                                      ).iconTheme.color?.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No discussions found',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color
                                            ?.withOpacity(0.7),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                padding: EdgeInsets.only(top: 8),
                                addRepaintBoundaries: true,
                                cacheExtent: 500,
                                itemCount: state.posts.length,
                                itemBuilder: (context, index) {
                                  return PostWidget(
                                    post: state.posts[index],
                                    index: index,
                                    category: 'searched',
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
