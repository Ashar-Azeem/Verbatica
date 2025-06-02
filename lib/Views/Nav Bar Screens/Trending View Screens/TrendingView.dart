// ignore_for_file: file_names
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/Trending%20View%20BLOC/trending_view_bloc.dart';
import 'package:verbatica/UI_Components/TrendingPostComponents/TrendingPost.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/Trending%20View%20Screens/News.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/Trending%20View%20Screens/SearchScreen.dart';
import 'package:verbatica/model/Post.dart';
import 'package:verbatica/model/news.dart';

class TrendingView extends StatefulWidget {
  const TrendingView({super.key});

  @override
  State<TrendingView> createState() => _TrendingViewState();
}

class _TrendingViewState extends State<TrendingView> {
  @override
  void initState() {
    super.initState();
    context.read<TrendingViewBloc>().add(FetchInitialTrendingPosts());
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
            child: NestedScrollView(
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
                                  if (value == 1 && state.news.isEmpty) {
                                    //Fetching this event here because we don't want to load the content of the following without being there
                                    context.read<TrendingViewBloc>().add(
                                      FetchInitialNews(),
                                    );
                                  }
                                },
                                tabs: const [
                                  Tab(text: 'Trending'),
                                  Tab(text: 'Top 10 news'),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],

              body: BlocBuilder<TrendingViewBloc, TrendingViewState>(
                buildWhen: (previous, current) {
                  return previous.trending != current.trending ||
                      previous.news != current.news;
                },
                builder: (context, state) {
                  return TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      // For You Tab
                      BuiltPostList(
                        posts: state.trending,
                        loading: state.trendingInitialLoading,
                        category: "Trending",
                      ),

                      // Following Tab
                      BuiltPostList(
                        news: state.news,
                        loading: state.newsInitialLoading,
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
  final bool loading;
  final String category;

  const BuiltPostList({
    super.key,
    this.posts,
    this.news,
    required this.loading,
    required this.category,
  });

  @override
  State<BuiltPostList> createState() => _BuiltPostListState();
}

class _BuiltPostListState extends State<BuiltPostList>
    with AutomaticKeepAliveClientMixin {
  late final List<DateTime> last7Days;
  late DateTime selectedDay;
  Country? selectedCountry;

  @override
  void initState() {
    super.initState();
    last7Days = List.generate(
      7,
      (i) => DateTime.now().subtract(Duration(days: i)).copyWithoutTime(),
    );
    selectedDay = last7Days.first;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.loading
        ? Center(
          child: LoadingAnimationWidget.dotsTriangle(
            color: Theme.of(context).colorScheme.primary,
            size: 10.w,
          ),
        )
        : widget.category == 'Trending'
        ? ListView.builder(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(top: 8),
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          cacheExtent: 500,
          itemCount: widget.posts!.length,
          itemBuilder: (context, index) {
            return TrendingPostWidget(
              post: widget.posts![index],
              index: index,
              category: widget.category,
              onFullView: false,
            );
          },
        )
        : ListView.builder(
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
                                minimumSize: const Size(
                                  120,
                                  48,
                                ), // width, height
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
                                  exclude: ["IL"],
                                  useSafeArea: true,
                                  countryListTheme: CountryListThemeData(
                                    searchTextStyle: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).textTheme.bodyLarge?.color,
                                    ),
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
                                    });
                                  },
                                );
                              },
                              icon: const Icon(Icons.flag),
                              label: Text(
                                selectedCountry?.name ?? 'Select Country',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
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
                                                    Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.color,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedDay = value!;
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
                  ],
                )
                : NewsView(index: index - 1, news: widget.news![index - 1]);
          },
        );
  }

  @override
  bool get wantKeepAlive => true;
}

extension DateUtils on DateTime {
  DateTime copyWithoutTime() => DateTime(year, month, day);
}
