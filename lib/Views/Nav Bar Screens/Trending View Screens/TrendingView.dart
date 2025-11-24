// ignore_for_file: file_names
import 'package:country_picker/country_picker.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/Trending%20View%20BLOC/trending_view_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/UI_Components/Ad_component/adComponent.dart';
import 'package:verbatica/UI_Components/PostComponents/EmptyPosts.dart';
import 'package:verbatica/UI_Components/PostComponents/PostUI.dart';
import 'package:verbatica/UI_Components/PostComponents/ShimmerLoader.dart';
import 'package:verbatica/Utilities/Color.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/Trending%20View%20Screens/News.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/Trending%20View%20Screens/SearchScreen.dart';
import 'package:verbatica/model/Ad.dart';
import 'package:verbatica/model/FeedItem.dart';
import 'package:verbatica/model/Post.dart';
import 'package:verbatica/model/news.dart';

class TrendingView extends StatefulWidget {
  const TrendingView({super.key});

  @override
  State<TrendingView> createState() => _TrendingViewState();
}

class _TrendingViewState extends State<TrendingView> {
  bool fetchNews = true;
  @override
  void initState() {
    super.initState();
    context.read<TrendingViewBloc>().add(
      FetchInitialTrendingPosts(
        userId: context.read<UserBloc>().state.user!.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: DefaultTabController(
        length: 2,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 1.w, right: 1.w),
            child: ExtendedNestedScrollView(
              onlyOneScrollInBody: true,
              physics: NeverScrollableScrollPhysics(),
              headerSliverBuilder:
                  (context, innerBoxIsScrolled) => [
                    SliverAppBar(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      automaticallyImplyLeading: false,
                      toolbarHeight: 12.h,
                      floating: true,
                      snap: true,
                      pinned: false,
                      title: Column(
                        children: [
                          SizedBox(
                            height: 5.h,
                            width: 90.w,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isDarkMode
                                        ? const Color(0xFF27343D)
                                        : const Color.fromARGB(
                                          255,
                                          247,
                                          246,
                                          246,
                                        ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              onPressed: () {
                                pushScreen(
                                  context,
                                  screen: SearchView(),
                                  withNavBar: false,
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.search,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 17),
                                    child: Text(
                                      'Search',
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.color
                                            ?.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          BlocBuilder<TrendingViewBloc, TrendingViewState>(
                            builder: (context, state) {
                              return TabBar(
                                dividerColor: Theme.of(context).dividerColor,

                                indicatorColor:
                                    Theme.of(context).colorScheme.primary,
                                labelColor:
                                    Theme.of(context).colorScheme.primary,
                                unselectedLabelColor:
                                    Theme.of(context).colorScheme.secondary,

                                onTap: (value) {
                                  //Only Called once
                                  if (value == 1 && fetchNews) {
                                    //Fetching this event here because we don't want to load the content of the following without being there
                                    String country =
                                        context
                                            .read<UserBloc>()
                                            .state
                                            .user!
                                            .country;
                                    context.read<TrendingViewBloc>().add(
                                      FetchInitialNews(
                                        country: country,
                                        date: DateTime.now(),
                                      ),
                                    );
                                    setState(() {
                                      fetchNews = false;
                                    });
                                  }
                                },
                                tabs: const [
                                  Tab(text: 'Trending'),
                                  Tab(text: 'Top news'),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],

              body: BlocBuilder<TrendingViewBloc, TrendingViewState>(
                builder: (context, state) {
                  return TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      // For You Tab
                      RefreshIndicator(
                        onRefresh: () async {
                          context.read<TrendingViewBloc>().add(
                            RefreshTrendingView(
                              userId: context.read<UserBloc>().state.user!.id,
                            ),
                          );
                          await Future.delayed(Duration(seconds: 2));
                        },
                        child: BuiltPostList(
                          posts: state.trending,
                          loading: state.trendingInitialLoading,
                          category: "Trending",
                          ads: state.ads,
                          hasMore: state.trendingBottomLoading,
                        ),
                      ),

                      // Following Tab
                      BuiltPostList(
                        news: state.news,
                        ads: [],
                        loading: state.newsInitialLoading,
                        hasMore: false,
                        category: "Top 10 news",
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BuiltPostList extends StatefulWidget {
  final List<Post>? posts;
  final List<News>? news;
  final List<Ad> ads;
  final bool loading;
  final String category;
  final bool hasMore;

  const BuiltPostList({
    super.key,
    this.posts,
    this.news,
    required this.loading,
    required this.category,
    required this.hasMore,
    required this.ads,
  });

  @override
  State<BuiltPostList> createState() => _BuiltPostListState();
}

class _BuiltPostListState extends State<BuiltPostList>
    with AutomaticKeepAliveClientMixin {
  late final List<DateTime> last7Days;
  late DateTime selectedDay;
  late Country selectedCountry;

  @override
  void initState() {
    super.initState();
    selectedCountry = Country.parse(
      context.read<UserBloc>().state.user!.country,
    );
    last7Days = List.generate(
      7,
      (i) => DateTime.now().subtract(Duration(days: i)).copyWithoutTime(),
    );
    selectedDay = last7Days.first;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (widget.loading) {
      return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return widget.category == 'Trending'
              ? PostShimmerTile()
              : NewsShimmerTile();
        },
      );
    } else if (widget.category == 'Trending') {
      // 🔹 Step 3: Combine posts & ads into one feed
      final combinedFeed = <FeedItem>[];
      for (int i = 0; i < widget.posts!.length; i++) {
        combinedFeed.add(widget.posts![i]);

        // Only add ad after every 10 posts *if ads remain*
        if ((i + 1) % 10 == 0 && i ~/ 10 < widget.ads.length) {
          combinedFeed.add(widget.ads[i ~/ 10]);
        }
      }
      return ListView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: 8),
        addAutomaticKeepAlives: true,
        addRepaintBoundaries: true,
        cacheExtent: 500,
        itemCount: widget.posts!.length + (widget.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == widget.posts!.length) {
            final userId = context.read<UserBloc>().state.user!.id;
            context.read<TrendingViewBloc>().add(
              FetchBottomTrendingPosts(userId: userId),
            );
            return Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 3.h),
              child: LoadingAnimationWidget.dotsTriangle(
                color: primaryColor,
                size: 12.w,
              ),
            );
          }
          final item = combinedFeed[index];
          if (item is Post) {
            return PostWidget(
              post: item,
              index: widget.posts!.indexWhere((p) => p.id == item.id),
              category: widget.category,
              onFullView: false,
            );
          } else if (item is Ad) {
            return AdCard(ad: item);
          }
          return const SizedBox.shrink();
        },
      );
    } else {
      return ListView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: 8),
        addAutomaticKeepAlives: true,
        addRepaintBoundaries: true,
        cacheExtent: 500,
        itemCount: widget.news!.length + 1,
        itemBuilder: (context, index) {
          return index == 0
              ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: SizedBox(
                      width: 90.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // 🌍 Country Picker Button
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(120, 48), // width, height
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              showCountryPicker(
                                countryFilter: [
                                  'US',
                                  'GB',
                                  'IN',
                                  'PK',
                                  'RU',
                                  'CN',
                                ],
                                showSearch: false,
                                useSafeArea: true,
                                countryListTheme: CountryListThemeData(
                                  padding: EdgeInsets.only(top: 2.h),
                                  bottomSheetHeight: 60.h,
                                  flagSize: 10.w,
                                  backgroundColor:
                                      Theme.of(context).dialogBackgroundColor,
                                  textStyle: TextStyle(
                                    color:
                                        Theme.of(
                                          context,
                                        ).textTheme.bodyLarge?.color,
                                  ),
                                ),
                                context: context,
                                showPhoneCode: false,
                                onSelect: (Country country) {
                                  setState(() {
                                    selectedCountry = country;
                                    context.read<TrendingViewBloc>().add(
                                      FetchInitialNews(
                                        country: selectedCountry.name,
                                        date: selectedDay,
                                      ),
                                    );
                                  });
                                },
                              );
                            },
                            icon: const Icon(Icons.flag),
                            label: Text(
                              selectedCountry.name,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),

                          // 📅 Day Selector
                          DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 3.w),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<DateTime>(
                                  borderRadius: BorderRadius.circular(10),
                                  value: selectedDay,
                                  dropdownColor:
                                      Theme.of(
                                        context,
                                      ).colorScheme.surfaceContainer,
                                  items:
                                      last7Days.map((day) {
                                        return DropdownMenuItem(
                                          value: day,
                                          child: Text(
                                            DateFormat(
                                              'EEE, MMM d',
                                            ).format(day),
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.bodyLarge?.color,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedDay = value!;
                                      context.read<TrendingViewBloc>().add(
                                        FetchInitialNews(
                                          country: selectedCountry.name,
                                          date: selectedDay,
                                        ),
                                      );
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (widget.news!.isEmpty)
                    ListView(
                      shrinkWrap: true,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Center(
                            child: BuildEmptyTabContent(
                              icon: Icons.article_outlined,
                              message: 'No news',
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              )
              : NewsView(index: index - 1, news: widget.news![index - 1]);
        },
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}

extension DateUtils on DateTime {
  DateTime copyWithoutTime() => DateTime(year, month, day);
}
