import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/ProfileView/otherprofile.dart';
import 'package:verbatica/model/user.dart';

class SearchedUser extends StatelessWidget {
  final User user;
  const SearchedUser({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(left: 1.5.w, right: 1.5.w, top: 0.8.h),
        child: Card(
          child: InkWell(
            onTap: () {
              pushScreen(
                context,
                screen: otherProfileView(user: user, post: null),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey,
                    backgroundImage: AssetImage(
                      'assets/Avatars/avatar${user.avatarId}.jpg',
                    ),
                  ),
                  SizedBox(width: 12),

                  Text(
                    user.userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
