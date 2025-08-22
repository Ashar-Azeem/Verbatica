// ignore_for_file: file_names

import 'package:verbatica/model/Post.dart';

// List 1: 3 clusters
List<String> clusters1 = ['Technology', 'Science', 'Programming'];

// List 2: 4 clusters
List<String> clusters2 = ['Sports', 'Health', 'Fitness', 'Nutrition'];

// List 3: 2 clusters
List<String> clusters3 = ['Art', 'Music'];

List<Post> forYouPosts = [
  Post(
    id: '1',
    userId: 35,
    name: 'Tech News',
    avatar: 4,
    title: 'New Smartphone Released',
    description:
        'The latest flagship phone with revolutionary camera technology has been unveiled today.',
    postImageLink: 'https://picsum.photos/500/300?random=1',
    isDebate: false,
    upvotes: 245,
    downvotes: 22,
    isUpVote: true,
    isDownVote: false,
    comments: 32,
    uploadTime: DateTime.now().subtract(Duration(hours: 2)),
  ),
  Post(
    id: '2',
    userId: 35,
    name: 'Travel Enthusiast',
    avatar: 1,
    title: 'Hidden Beach in Thailand',
    description:
        'Found this amazing secluded beach that most tourists don\'t know about!',
    postImageLink: 'https://picsum.photos/500/300?random=2',
    isDebate: false,
    upvotes: 45,
    downvotes: 22,
    isUpVote: false,
    isDownVote: true,
    comments: 24,
    uploadTime: DateTime.now().subtract(Duration(hours: 5)),
  ),
  Post(
    id: '3',
    userId: 36,
    name: 'Debate Master',
    avatar: 2,
    title: 'Android vs iOS: Which is better?',
    description:
        'Let\'s settle this debate once and for all. Share your thoughts below!',
    postImageLink: 'https://picsum.photos/500/300?random=3',
    isDebate: true,
    upvotes: 200,
    downvotes: 29,
    isUpVote: false,
    isDownVote: false,
    comments: 87,
    clusters: clusters1,
    uploadTime: DateTime.now().subtract(Duration(hours: 8)),
  ),
  Post(
    id: '4',
    userId: 37,
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
    isUpVote: true,
    isDownVote: false,
    comments: 18,
    uploadTime: DateTime.now().subtract(Duration(hours: 12)),
  ),
  Post(
    id: '5',
    userId: 38,
    name: 'Fitness Coach',
    avatar: 7,
    title: 'Morning Workout Routine',
    description: 'Start your day right with these 5 simple exercises...',
    postImageLink: 'https://picsum.photos/500/300?random=4',
    isDebate: false,
    upvotes: 1000,
    downvotes: 200,
    isUpVote: false,
    isDownVote: true,
    comments: 42,
    uploadTime: DateTime.now().subtract(Duration(days: 1)),
  ),
];
