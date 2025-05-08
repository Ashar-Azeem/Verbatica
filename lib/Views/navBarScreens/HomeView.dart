// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/UI_Components/PostComponents/PostUI.dart';
import 'package:verbatica/Utilities/Color.dart';
import 'package:verbatica/model/Post.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      backgroundColor: Color.fromARGB(255, 10, 13, 15),
                      automaticallyImplyLeading: false,
                      toolbarHeight: 12.h,
                      floating: true,
                      snap: true,
                      pinned: false,
                      title: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'assets/Logo.png',
                                width: 40,
                                height: 40,
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.message_outlined,
                                  color: primaryColor,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          TabBar(
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
                        ],
                      ),
                    ),
                  ],

              body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  // For You Tab
                  BuiltPostList(posts: forYouPosts),

                  // Following Tab
                  BuiltPostList(posts: followingPosts),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BuiltPostList extends StatefulWidget {
  final List<Post> posts;

  const BuiltPostList({super.key, required this.posts});

  @override
  State<BuiltPostList> createState() => _BuiltPostListState();
}

class _BuiltPostListState extends State<BuiltPostList>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(top: 8),
      addAutomaticKeepAlives: true,
      addRepaintBoundaries: true,
      cacheExtent: 500,
      itemCount: widget.posts.length,
      itemBuilder: (context, index) {
        return PostWidget(post: widget.posts[index]);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

// Generate dummy posts
List<Post> forYouPosts = [
  Post(
    id: '1',
    name: 'Tech News',
    avatar: 1,
    title: 'New Smartphone Released',
    description:
        'The latest flagship phone with revolutionary camera technology has been unveiled today.',
    postImageLink: 'https://picsum.photos/500/300?random=1',
    isDebate: false,
    upvotes: 245,
    downvotes: 22,
    comments: 32,
    uploadTime: DateTime.now().subtract(Duration(hours: 2)),
  ),
  Post(
    id: '2',
    name: 'Travel Enthusiast',
    avatar: 1,

    title: 'Hidden Beach in Thailand',
    description:
        'Found this amazing secluded beach that most tourists don\'t know about!',
    postImageLink: 'https://picsum.photos/500/300?random=2',

    isDebate: false,
    upvotes: 45,
    downvotes: 22,
    comments: 24,
    uploadTime: DateTime.now().subtract(Duration(hours: 5)),
  ),
  Post(
    id: '3',
    name: 'Debate Master',
    avatar: 1,
    title: 'Android vs iOS: Which is better?',
    description:
        'Let\'s settle this debate once and for all. Share your thoughts below!',
    postImageLink: 'https://picsum.photos/500/300?random=3',
    isDebate: true,
    upvotes: 200,
    downvotes: 29,
    comments: 87,
    uploadTime: DateTime.now().subtract(Duration(hours: 8)),
  ),
  Post(
    id: '4',
    name: 'Food Blogger',
    avatar: 1,
    title: 'Easy 10-minute Pasta Recipe',
    description:
        'Perfect for when you\'re too tired to cook but want something delicious!',
    postVideoLink:
        'https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4',
    isDebate: false,
    upvotes: 20,
    downvotes: 29,
    comments: 18,
    uploadTime: DateTime.now().subtract(Duration(hours: 12)),
  ),
  Post(
    id: '5',
    name: 'Fitness Coach',
    avatar: 1,
    title: 'Morning Workout Routine',
    description:
        'Start your day right with these 5 simple exercises dfknskdnflskdnfnsldnfsjndfjsdf sdj fsjd gjsd gkjd fgkjs dgsjkd gjk',
    postImageLink: 'https://picsum.photos/500/300?random=4',
    isDebate: false,
    upvotes: 1000,
    downvotes: 200,
    comments: 42,
    uploadTime: DateTime.now().subtract(Duration(days: 1)),
  ),
];

List<Post> followingPosts = [
  Post(
    id: '101',
    name: 'Sarah Johnson',
    avatar: 1,
    title: 'My New Art Project',
    description:
        'After months of work, finally revealed my latest painting series!',
    postVideoLink:
        'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4',
    isDebate: false,
    upvotes: 109,
    downvotes: 0,
    comments: 15,
    uploadTime: DateTime.now().subtract(Duration(hours: 1)),
  ),
  Post(
    id: '102',
    name: 'Mike Chen',
    avatar: 1,
    title: 'Tech Startup Update',
    description:
        'We just secured our Series A funding! Big things coming soon.',
    isDebate: false,
    upvotes: 47,
    downvotes: 21,
    comments: 45,
    uploadTime: DateTime.now().subtract(Duration(hours: 3)),
  ),
  Post(
    id: '103',
    name: 'Alex Taylor',
    avatar: 1,
    title: 'Should remote work be the default?',
    description:
        'With offices reopening, let\'s discuss the future of work arrangements',
    isDebate: true,
    upvotes: 490,
    downvotes: 89,
    comments: 62,
    uploadTime: DateTime.now().subtract(Duration(hours: 6)),
  ),
  Post(
    id: '104',
    name: 'David Kim',
    avatar: 1,
    title: 'Guitar Cover - Latest Pop Hit',
    description: 'Tried my hand at covering this week\'s #1 song',
    postVideoLink:
        'https://download.blender.org/durian/trailer/sintel_trailer-480p.mp4',
    isDebate: false,
    upvotes: 430,
    downvotes: 90,
    comments: 12,
    uploadTime: DateTime.now().subtract(Duration(days: 1)),
  ),
  Post(
    id: '105',
    name: 'Emma Wilson',
    avatar: 1,
    title: 'Book Recommendation',
    description:
        'Just finished this amazing novel - highly recommend to all fiction lovers!',
    postImageLink: 'https://picsum.photos/500/300?random=105',
    isDebate: false,
    upvotes: 145,
    downvotes: 49,
    comments: 9,
    uploadTime: DateTime.now().subtract(Duration(days: 2)),
  ),
  Post(
    id: '106',
    name: 'James Rodriguez',
    avatar: 1,
    title: 'Photography Tips',
    description: '5 composition techniques that improved my photos instantly',
    postImageLink: 'https://picsum.photos/500/300?random=106',
    isDebate: false,
    upvotes: 123,
    downvotes: 321,
    comments: 21,
    uploadTime: DateTime.now().subtract(Duration(days: 3)),
  ),
];
