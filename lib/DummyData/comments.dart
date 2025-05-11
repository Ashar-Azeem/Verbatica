import 'package:verbatica/model/comment.dart';

List<Comment> dummyComments = [
  Comment(
    id: '1',
    text: 'This is comment #1, level 1',
    author: 'User2',
    profile: '5',
    parentId: null,
    uploadTime: DateTime.now().subtract(Duration(days: 2)), // 2 days ago
    upVotes: 15,
    downVotes: 3,
    allReplies: [
      Comment(
        id: '2',
        text: 'This is comment #2, level 2',
        author: 'User4',
        profile: '3',
        parentId: '1',
        uploadTime: DateTime.now().subtract(Duration(days: 1)), // 1 day ago
        upVotes: 8,
        downVotes: 2,
        allReplies: [
          Comment(
            id: '3',
            text: 'This is comment #3, level 3',
            author: 'User3',
            profile: '2',
            parentId: '2',
            uploadTime: DateTime.now().subtract(
              Duration(hours: 5),
            ), // 5 hours ago
            upVotes: 5,
            downVotes: 0,
            allReplies: [],
          ),
        ],
      ),
    ],
  ),
  Comment(
    id: '2',
    text: 'This is comment #2, level 1',
    author: 'User1',
    profile: '2',
    parentId: null,
    uploadTime: DateTime.now().subtract(Duration(days: 4)), // 4 days ago
    upVotes: 12,
    downVotes: 4,
    allReplies: [
      Comment(
        id: '3',
        text: 'This is comment #3, level 2',
        author: 'User2',
        profile: '5',
        parentId: '2',
        uploadTime: DateTime.now().subtract(Duration(days: 3)), // 3 days ago
        upVotes: 6,
        downVotes: 1,
        allReplies: [
          Comment(
            id: '4',
            text: 'This is comment #4, level 3',
            author: 'User3',
            profile: '3',
            parentId: '3',
            uploadTime: DateTime.now().subtract(
              Duration(days: 2),
            ), // 2 days ago
            upVotes: 3,
            downVotes: 0,
            allReplies: [],
          ),
        ],
      ),
    ],
  ),
  Comment(
    id: '3',
    text: 'This is comment #3, level 1',
    author: 'User5',
    profile: '1',
    parentId: null,
    uploadTime: DateTime.now().subtract(Duration(days: 5)), // 5 days ago
    upVotes: 20,
    downVotes: 5,
    allReplies: [],
  ),
  Comment(
    id: '4',
    text: 'This is comment #4, level 1',
    author: 'User1',
    profile: '3',
    parentId: null,
    uploadTime: DateTime.now().subtract(Duration(days: 3)), // 3 days ago
    upVotes: 10,
    downVotes: 2,
    allReplies: [
      Comment(
        id: '5',
        text: 'This is comment #5, level 2',
        author: 'User3',
        profile: '4',
        parentId: '4',
        uploadTime: DateTime.now().subtract(Duration(days: 2)), // 2 days ago
        upVotes: 7,
        downVotes: 1,
        allReplies: [
          Comment(
            id: '6',
            text: 'This is comment #6, level 3',
            author: 'User2',
            profile: '5',
            parentId: '5',
            uploadTime: DateTime.now().subtract(Duration(days: 1)), // 1 day ago
            upVotes: 4,
            downVotes: 0,
            allReplies: [],
          ),
        ],
      ),
    ],
  ),
  Comment(
    id: '5',
    text: 'This is comment #5, level 1',
    author: 'User4',
    profile: '2',
    parentId: null,
    uploadTime: DateTime.now().subtract(Duration(days: 6)), // 6 days ago
    upVotes: 5,
    downVotes: 3,
    allReplies: [],
  ),
];
