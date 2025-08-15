import 'package:verbatica/model/Post.dart';
import 'package:verbatica/model/news.dart';
import 'package:verbatica/DummyData/dummyPosts.dart';

final List<News> newsList = [
  News(
    newsId: 'n101',
    title: 'AI Breakthrough in Healthcare',
    description:
        'A new AI model is now able to detect early-stage cancer with over 95% accuracy.',
    url: 'https://www.bbc.com/news/health-ai-cancer',
    image:
        'https://nypost.com/wp-content/uploads/sites/2/2023/03/NYPICHPDPICT000008528195.jpg',
    publishedAt: DateTime.now().subtract(Duration(hours: 5)),
    sourceName: 'BBC News',
    sourceUrl: 'https://www.bbc.com',
    discussions: [
      Post(
        id: '301',
        name: 'Dr. Smith',
        userId: 40,
        avatar: 2,
        title: 'Will this AI help doctors or replace them?',
        description:
            'I think it will enhance diagnosis, but people fear job loss.',
        isDebate: true,
        upvotes: 120,
        downvotes: 10,
        comments: 15,
        uploadTime: DateTime.now().subtract(Duration(hours: 4)),
        clusters: clusters1,
        isUpVote: false,
        isDownVote: false,
      ),
    ],
  ),
  News(
    newsId: 'n102',
    title: 'Massive Solar Storm Hits Earth',
    description:
        'The strongest solar storm in 20 years has disrupted GPS signals and caused stunning auroras worldwide.',
    url: 'https://www.space.com/solar-storm-may-2025-effects',
    image:
        'https://i.ytimg.com/vi/q2kDvrs2VEs/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLCqrK8ISzpB5krC2jzGHuv-ODlDPw',
    publishedAt: DateTime.now().subtract(Duration(days: 1)),
    sourceName: 'Space.com',
    sourceUrl: 'https://www.space.com',
    discussions: [
      Post(
        id: '302',
        userId: 42,
        name: 'SkyWatcher',
        avatar: 3,
        title: 'I saw the auroras in Texas!',
        description: 'Never thought I’d see them this far south. Incredible.',
        isDebate: false,
        upvotes: 200,
        downvotes: 5,
        comments: 10,
        uploadTime: DateTime.now().subtract(Duration(hours: 20)),
        isUpVote: true,
        isDownVote: false,
      ),
      Post(
        id: '303',
        name: 'Engineer101',
        avatar: 4,
        userId: 43,
        title: 'Are our satellites safe?',
        description:
            'How do solar storms affect our satellite systems and internet?',
        isDebate: true,
        upvotes: 95,
        downvotes: 12,
        comments: 8,
        uploadTime: DateTime.now().subtract(Duration(hours: 18)),
        clusters: clusters2,
        isUpVote: false,
        isDownVote: false,
      ),
    ],
  ),
  News(
    newsId: 'n103',
    title: 'Election Results Announced',
    description:
        'The national elections concluded with a surprising victory for the newcomer party.',
    url: 'https://www.reuters.com/world/elections-2025-results/',
    image:
        'https://static01.nyt.com/images/2024/02/10/multimedia/10pakistan-01-hzwc/10pakistan-01-hzwc-superJumbo.jpg',
    publishedAt: DateTime.now().subtract(Duration(hours: 8)),
    sourceName: 'Reuters',
    sourceUrl: 'https://www.reuters.com',
    discussions: [
      Post(
        id: '304',
        name: 'CivicVoice',
        avatar: 5,
        userId: 45,
        title: 'A political shake-up?',
        description:
            'What does this win mean for our economy and international relations?',
        isDebate: true,
        upvotes: 300,
        downvotes: 25,
        comments: 50,
        uploadTime: DateTime.now().subtract(Duration(hours: 7)),
        clusters: clusters1,
        isUpVote: true,
        isDownVote: false,
      ),
    ],
  ),
];
