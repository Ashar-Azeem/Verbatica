// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/UI_Components/PostUI.dart';
import 'package:verbatica/Utilities/Color.dart';
import 'package:verbatica/model/Post.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 1.w, right: 1.w),
          child: NestedScrollView(
            headerSliverBuilder:
                (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    backgroundColor: Color.fromARGB(255, 10, 13, 15),
                    automaticallyImplyLeading: false,
                    toolbarHeight: 6.h, // normal AppBar height
                    floating: true,
                    snap: true,
                    pinned: false,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset('assets/Logo.png', width: 40, height: 40),
                        IconButton(
                          icon: Icon(
                            Icons.message_outlined,
                            color: primaryColor,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),

                  SliverAppBar(
                    backgroundColor: Color.fromARGB(255, 10, 13, 15),
                    automaticallyImplyLeading: false,
                    toolbarHeight: 7.h, // just enough for TabBar
                    pinned: false,
                    floating: true,
                    snap: true,
                    title: TabBar(
                      controller: _tabController,
                      indicatorColor: primaryColor,
                      labelColor: primaryColor,
                      unselectedLabelColor: const Color.fromARGB(
                        255,
                        196,
                        195,
                        195,
                      ),
                      tabs: const [
                        Tab(text: 'For You'),
                        Tab(text: 'Following'),
                      ],
                    ),
                  ),
                ],

            body: TabBarView(
              physics: AlwaysScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                // For You Tab
                _buildPostList('For You', forYouPosts),

                // Following Tab
                _buildPostList('Following', followingPosts),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPostList(String type, List<Post> posts) {
    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 8),
      itemCount: 10,
      itemBuilder: (context, index) {
        return PostWidget(
          postIndex: index,
          postType: type,
          backgroundColor: Color.fromARGB(255, 19, 26, 31),
        );
      },
    );
  }
}

// Generate dummy posts
List<Post> forYouPosts = [
  Post(
    id: '1',
    name: 'Tech News',
    avatar: 'https://randomuser.me/api/portraits/tech/1.jpg',
    title: 'New Smartphone Released',
    description:
        'The latest flagship phone with revolutionary camera technology has been unveiled today.',
    postImageLink: 'https://picsum.photos/500/300?random=1',
    isDebate: false,
    likes: 245,
    comments: 32,
    uploadTime: DateTime.now().subtract(Duration(hours: 2)),
  ),
  Post(
    id: '2',
    name: 'Travel Enthusiast',
    avatar: 'https://randomuser.me/api/portraits/lego/2.jpg',
    title: 'Hidden Beach in Thailand',
    description:
        'Found this amazing secluded beach that most tourists don\'t know about!',
    postImageLink: 'https://picsum.photos/500/300?random=2',
    postVideoLink: 'https://example.com/videos/beach.mp4',
    isDebate: false,
    likes: 189,
    comments: 24,
    uploadTime: DateTime.now().subtract(Duration(hours: 5)),
  ),
  Post(
    id: '3',
    name: 'Debate Master',
    avatar: 'https://randomuser.me/api/portraits/robot/3.jpg',
    title: 'Android vs iOS: Which is better?',
    description:
        'Let\'s settle this debate once and for all. Share your thoughts below!',
    postImageLink: 'https://picsum.photos/500/300?random=3',
    isDebate: true,
    likes: 432,
    comments: 87,
    uploadTime: DateTime.now().subtract(Duration(hours: 8)),
  ),
  Post(
    id: '4',
    name: 'Food Blogger',
    avatar: 'https://randomuser.me/api/portraits/women/4.jpg',
    title: 'Easy 10-minute Pasta Recipe',
    description:
        'Perfect for when you\'re too tired to cook but want something delicious!',
    postVideoLink: 'https://example.com/videos/pasta.mp4',
    isDebate: false,
    likes: 156,
    comments: 18,
    uploadTime: DateTime.now().subtract(Duration(hours: 12)),
  ),
  Post(
    id: '5',
    name: 'Fitness Coach',
    avatar: 'https://randomuser.me/api/portraits/men/5.jpg',
    title: 'Morning Workout Routine',
    description: 'Start your day right with these 5 simple exercises',
    postImageLink: 'https://picsum.photos/500/300?random=4',
    isDebate: false,
    likes: 321,
    comments: 42,
    uploadTime: DateTime.now().subtract(Duration(days: 1)),
  ),
];

List<Post> followingPosts = [
  Post(
    id: '101',
    name: 'Sarah Johnson',
    avatar: 'https://randomuser.me/api/portraits/women/10.jpg',
    title: 'My New Art Project',
    description:
        'After months of work, finally revealed my latest painting series!',
    postImageLink: 'https://picsum.photos/500/300?random=101',
    isDebate: false,
    likes: 87,
    comments: 15,
    uploadTime: DateTime.now().subtract(Duration(hours: 1)),
  ),
  Post(
    id: '102',
    name: 'Mike Chen',
    avatar: 'https://randomuser.me/api/portraits/men/11.jpg',
    title: 'Tech Startup Update',
    description:
        'We just secured our Series A funding! Big things coming soon.',
    isDebate: false,
    likes: 203,
    comments: 45,
    uploadTime: DateTime.now().subtract(Duration(hours: 3)),
  ),
  Post(
    id: '103',
    name: 'Alex Taylor',
    avatar: 'https://randomuser.me/api/portraits/women/12.jpg',
    title: 'Should remote work be the default?',
    description:
        'With offices reopening, let\'s discuss the future of work arrangements',
    isDebate: true,
    likes: 156,
    comments: 62,
    uploadTime: DateTime.now().subtract(Duration(hours: 6)),
  ),
  Post(
    id: '104',
    name: 'David Kim',
    avatar: 'https://randomuser.me/api/portraits/men/13.jpg',
    title: 'Guitar Cover - Latest Pop Hit',
    description: 'Tried my hand at covering this week\'s #1 song',
    postVideoLink: 'https://example.com/videos/guitar.mp4',
    isDebate: false,
    likes: 98,
    comments: 12,
    uploadTime: DateTime.now().subtract(Duration(days: 1)),
  ),
  Post(
    id: '105',
    name: 'Emma Wilson',
    avatar: 'https://randomuser.me/api/portraits/women/14.jpg',
    title: 'Book Recommendation',
    description:
        'Just finished this amazing novel - highly recommend to all fiction lovers!',
    postImageLink: 'https://picsum.photos/500/300?random=105',
    isDebate: false,
    likes: 76,
    comments: 9,
    uploadTime: DateTime.now().subtract(Duration(days: 2)),
  ),
  Post(
    id: '106',
    name: 'James Rodriguez',
    avatar: 'https://randomuser.me/api/portraits/men/15.jpg',
    title: 'Photography Tips',
    description: '5 composition techniques that improved my photos instantly',
    postImageLink: 'https://picsum.photos/500/300?random=106',
    isDebate: false,
    likes: 134,
    comments: 21,
    uploadTime: DateTime.now().subtract(Duration(days: 3)),
  ),
];
