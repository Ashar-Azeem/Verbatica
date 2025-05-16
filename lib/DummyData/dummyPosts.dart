// Generate dummy posts
import 'package:verbatica/model/Post.dart';

// List 1: 3 clusters
List<Cluster> clusters1 = [
  Cluster(id: '1', title: 'Technology'),
  Cluster(id: '2', title: 'Science'),
  Cluster(id: '3', title: 'Programming'),
];

// List 2: 4 clusters
List<Cluster> clusters2 = [
  Cluster(id: '4', title: 'Sports'),
  Cluster(id: '5', title: 'Health'),
  Cluster(id: '6', title: 'Fitness'),
  Cluster(id: '7', title: 'Nutrition'),
];

// List 3: 2 clusters
List<Cluster> clusters3 = [
  Cluster(id: '8', title: 'Art'),
  Cluster(id: '9', title: 'Music'),
];
List<Post> forYouPosts = [
  Post(
    id: '1',
    name: 'Tech News',
    avatar: 4,
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
    avatar: 3,

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
    avatar: 2,
    title: 'Android vs iOS: Which is better?',
    description:
        'Let\'s settle this debate once and for all. Share your thoughts below!',
    postImageLink: 'https://picsum.photos/500/300?random=3',
    isDebate: true,
    upvotes: 200,
    downvotes: 29,
    comments: 87,
    clusters: clusters1,
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
    avatar: 7,
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
    avatar: 6,
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
    avatar: 5,
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
    avatar: 4,
    title: 'Should remote work be the default?',
    description:
        'With offices reopening, let\'s discuss the future of work arrangements',
    isDebate: true,
    upvotes: 490,
    downvotes: 89,
    comments: 62,
    clusters: clusters2,
    uploadTime: DateTime.now().subtract(Duration(hours: 6)),
  ),
  Post(
    id: '104',
    name: 'David Kim',
    avatar: 3,
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
    avatar: 2,
    title: 'Photography Tips',
    description: '5 composition techniques that improved my photos instantly',
    postImageLink: 'https://picsum.photos/500/300?random=106',
    isDebate: true,
    clusters: clusters3,
    upvotes: 123,
    downvotes: 321,
    comments: 21,
    uploadTime: DateTime.now().subtract(Duration(days: 3)),
  ),
];
