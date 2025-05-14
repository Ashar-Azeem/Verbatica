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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 3, 49, 119),
                  Colors.black, // Deep Blue
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: 5.0.h,
                right: 3.0.h, // This will now work
                left: 3.0.h, // Add left for symmetry
              ),
              child: SizedBox(
                width:
                    MediaQuery.of(context).size.width - 40, // Constrain width
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5.h),
                    CircleAvatar(
                      radius: 5.0.h,
                      backgroundImage: AssetImage(
                        'assets/Avatars/avatar${widget.post.avatar}.jpg',
                      ),
                    ),
                    SizedBox(height: 2.0.h),

                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(70, 50), // width, height
                            side: BorderSide(color: Colors.white),
                          ),
                          child: Text(
                            'Follow',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(70, 50),
                            side: BorderSide(color: Colors.grey, width: 2),
                            padding: EdgeInsets.all(12), // adjust size
                          ),
                          child: Icon(Icons.wechat_sharp, size: 28),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.0.h),
                    Text(
                      widget.post.name,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 1.0.h),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildStatItem(
                        'Aura',
                        '123', // Convert to string if needed
                      ),
                    ),

                    _buildInfoItem(
                      Icons.date_range,
                      formatJoinedDate(DateTime.now()),
                    ),
                  ],
                ),
              ),
            ),
          ),

          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Posts'),
              Tab(text: 'Comments'),
              Tab(text: 'About'),
            ],
            labelColor: Colors.blue,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelColor: Colors.grey,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(width: 2.0, color: Colors.blue),
            ),
          ),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Posts Tab
                const Center(
                  child: Text(
                    'Posts Content',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                // Comments Tab
                const Center(
                  child: Text(
                    'Comments Content',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                // About Tab
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'About',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nothing here',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoItem(
                        Icons.date_range,
                        formatJoinedDate(DateTime.now()),
                      ),

                      _buildInfoItem(Icons.location_on, 'Pakistan'),
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

  Widget _buildStatItem(String label, String value) {
    return Row(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        SizedBox(width: 10),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
