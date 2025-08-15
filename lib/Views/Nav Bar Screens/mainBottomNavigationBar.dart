// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_event.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/AddPostView.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/Home%20View%20Screens/HomeView.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/NotificationView.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/ProfileView/ProfileView.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/Trending%20View%20Screens/TrendingView.dart';
import 'package:verbatica/model/user.dart';

class BottomNavigationBarView extends StatefulWidget {
  final User? user;
  const BottomNavigationBarView({super.key, this.user});

  @override
  State<BottomNavigationBarView> createState() =>
      _BottomNavigationBarViewState();
}

class _BottomNavigationBarViewState extends State<BottomNavigationBarView> {
  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      context.read<UserBloc>().add(UpdateUser(widget.user!, context));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PersistentTabView(
      screenTransitionAnimation: ScreenTransitionAnimation.none(),
      tabs: [
        PersistentTabConfig(
          screen: HomeView(),
          item: ItemConfig(
            icon: Icon(Icons.home),
            activeForegroundColor: colorScheme.primary,
          ),
        ),
        PersistentTabConfig(
          screen: TrendingView(),
          item: ItemConfig(
            icon: Icon(Icons.trending_up),
            activeForegroundColor: colorScheme.primary,
          ),
        ),
        PersistentTabConfig(
          screen: CreatePostScreen(),
          item: ItemConfig(
            icon: Icon(Icons.add_circle_outlined),
            activeForegroundColor: colorScheme.primary,
          ),
        ),
        PersistentTabConfig(
          screen: NotificationScreen(),
          item: ItemConfig(
            icon: Icon(Icons.notifications_none_sharp),
            activeForegroundColor: colorScheme.primary,
          ),
        ),
        PersistentTabConfig(
          screen: ProfileView(),
          item: ItemConfig(
            icon: Icon(Icons.person),
            activeForegroundColor: colorScheme.primary,
          ),
        ),
      ],
      navBarBuilder: (p0) {
        return Style6BottomNavBar(
          navBarConfig: p0,
          navBarDecoration: NavBarDecoration(
            border: Border(
              top: BorderSide(
                color: colorScheme.outline.withOpacity(0.3),
                width: 0.2,
              ),
            ),
            color: theme.scaffoldBackgroundColor,
          ),
        );
      },
    );
  }
}
