// ignore_for_file: file_names, camel_case_types
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/otheruser/otheruser_bloc.dart';
import 'package:verbatica/Utilities/dateformat.dart';
import 'package:verbatica/model/Post.dart';

class otherProfileView extends StatefulWidget {
  const otherProfileView({required this.post, super.key});
  final Post post;
  @override
  State<otherProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<otherProfileView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    context.read<OtheruserBloc>().add(fetchUserinfo(Userid: widget.post.id));
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            height: 35.0.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1A237E), // Deeper indigo
                  Color(0xFF0D47A1), // Royal blue
                ],
                stops: [0.4, 1.0],
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Section with Back Button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                    ),
                  ),
                ),

                SizedBox(height: 1.0.h),

                // Profile Card
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 2.0.h),
                    padding: EdgeInsets.all(5.0.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Avatar
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 8.0.h,
                            backgroundImage: AssetImage(
                              'assets/Avatars/avatar${widget.post.avatar}.jpg',
                            ),
                          ),
                        ),

                        SizedBox(height: 2.0.h),

                        // Username
                        Text(
                          widget.post.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(height: 1.0.h),

                        // Aura Points
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.0.w,
                            vertical: 1.0.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF3949AB), Color(0xFF1E88E5)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                color: Colors.amber,
                                size: 20,
                              ),
                              SizedBox(width: 1.0.w),
                              Text(
                                '123 Aura',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 2.0.h),

                        // Join Date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cake, size: 18, color: Colors.grey[600]),
                            SizedBox(width: 1.0.w),
                            Text(
                              'Member since ${formatJoinedDate(DateTime.now())}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 3.0.h),

                        // Action Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Follow Button
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.person_add, size: 18),
                                label: Text('Follow'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[700],
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 1.2.h,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 3.0.w),
                            // Message Button
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[800],
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.0.w,
                                    vertical: 1.2.h,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Icon(Icons.message, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Tab Bar
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.article, size: 18),
                            SizedBox(width: 8),
                            Text('Posts'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.comment, size: 18),
                            SizedBox(width: 8),
                            Text('Comments'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person, size: 18),
                            SizedBox(width: 8),
                            Text('About'),
                          ],
                        ),
                      ),
                    ],
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(
                        width: 3.0,
                        color: Theme.of(context).primaryColor,
                      ),
                      insets: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    dividerColor: Colors.transparent,
                  ),
                ),

                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Posts Tab
                      _buildEmptyTabContent(
                        icon: Icons.article_outlined,
                        message: 'No posts yet',
                      ),

                      // Comments Tab
                      _buildEmptyTabContent(
                        icon: Icons.chat_bubble_outline,
                        message: 'No comments yet',
                      ),

                      // About Tab
                      SingleChildScrollView(
                        padding: EdgeInsets.all(5.0.w),
                        child: Container(
                          padding: EdgeInsets.all(5.0.w),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // About Section Header
                              Row(
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  SizedBox(width: 2.0.w),
                                  Text(
                                    'About',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),

                              Divider(height: 4.0.h),

                              // Bio
                              Container(
                                padding: EdgeInsets.all(3.0.w),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Nothing here',
                                  style: TextStyle(
                                    fontSize: 15,
                                    height: 1.5,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ),

                              SizedBox(height: 3.0.h),

                              // Member Since Info
                              _buildInfoItem(
                                icon: Icons.date_range,
                                iconColor: Colors.blue[700]!,
                                label: 'Member since',
                                value: formatJoinedDate(DateTime.now()),
                              ),

                              SizedBox(height: 2.0.h),

                              // Location Info
                              _buildInfoItem(
                                icon: Icons.location_on,
                                iconColor: Colors.red[400]!,
                                label: 'Location',
                                value: 'Pakistan',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTabContent({
    required IconData icon,
    required String message,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.0.w),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        SizedBox(width: 3.0.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: Colors.white)),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Row(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7)),
        ),
      ],
    );
  }
}
