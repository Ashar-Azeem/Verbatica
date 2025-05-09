// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart' show UserBloc;
import 'package:verbatica/BLOC/User%20bloc/user_event.dart' show UpdateUser;
import 'package:verbatica/Utilities/Color.dart';
import 'package:verbatica/Views/navBarScreens/AddPostView.dart';
import 'package:verbatica/Views/navBarScreens/HomeView.dart';
import 'package:verbatica/Views/navBarScreens/NotificationView.dart';
import 'package:verbatica/Views/navBarScreens/ProfileView/ProfileView.dart';
import 'package:verbatica/Views/navBarScreens/TrendingView.dart';
import 'package:verbatica/model/user.dart';

class BottomNavigationBarView extends StatelessWidget {
  const BottomNavigationBarView({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyUser = User(
      username: 'AnonymousRebel354',
      country: 'Pakistan',
      karma: 0,
      followers: 0,
      following: 0,
      joinedDate: DateTime.now(),

      about:
          'ahfhjadfbjdbfjshdbfhjsbfjhsdbfjsdfbsfhsjfjsfdbjsdfjhsfbjsfdjshf...',
      avatarId: 1,
    );

    // Dispatch event to update user in BLoC

    context.read<UserBloc>().add(UpdateUser(dummyUser));
    //Inserting the bottom nagivation bar here using the corresponding package and also initializing the blocs along side that we'll
    //also retreive the user from the DB
    return
    // MultiBlocProvider(
    //   providers: [
    //     // BlocProvider(
    //     //   create: (context) => SubjectBloc(),
    //     // ),
    //     // BlocProvider(
    //     //   create: (context) => SubjectBloc(),
    //     // ),
    //   ],
    //   child:
    PersistentTabView(
      screenTransitionAnimation: ScreenTransitionAnimation.none(),
      tabs: [
        PersistentTabConfig(
          screen: HomeView(),
          item: ItemConfig(
            icon: Icon(Icons.home),
            activeForegroundColor: primaryColor,
          ),
        ),
        PersistentTabConfig(
          screen: TrendingView(),
          item: ItemConfig(
            icon: Icon(Icons.trending_up),
            activeForegroundColor: primaryColor,
          ),
        ),
        PersistentTabConfig(
          screen: CreatePostScreen(),
          item: ItemConfig(
            icon: Icon(Icons.add_circle_outlined),
            activeForegroundColor: primaryColor,
          ),
        ),
        PersistentTabConfig(
          screen: NotificationScreen(),
          item: ItemConfig(
            icon: Icon(Icons.notifications_none_sharp),
            activeForegroundColor: primaryColor,
          ),
        ),
        PersistentTabConfig(
          screen: ProfileView(),
          item: ItemConfig(
            icon: Icon(Icons.person),
            activeForegroundColor: primaryColor,
          ),
        ),
      ],
      navBarBuilder: (p0) {
        return Style6BottomNavBar(
          navBarConfig: p0,
          navBarDecoration: NavBarDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.grey, // Your desired line color
                width: 0.2, // Thickness of the line
              ),
            ),
            color: Color.fromARGB(255, 10, 13, 15),
          ),
        );
      },
    );
    // );
  }
}
