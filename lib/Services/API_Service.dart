import 'dart:typed_data';

import 'package:chatview/chatview.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbatica/BLOC/Votes%20Restriction/votes_restrictor_bloc.dart';
import 'package:verbatica/LocalDB/TokenOperations.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/Analysis%20Views/chartanalytics.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/Analysis%20Views/chartanalyticsDetail.dart';
import 'package:verbatica/model/Ad.dart';
import 'package:verbatica/model/Chat.dart';
import 'package:verbatica/model/Post.dart';
import 'package:verbatica/model/comment.dart';
import 'package:verbatica/model/news.dart';
import 'package:verbatica/model/notification.dart';
import 'package:verbatica/model/report.dart';
import 'package:verbatica/model/summary.dart';
import 'package:verbatica/model/user.dart';

class ApiService {
  final Dio _dio = Dio(
      BaseOptions(
        baseUrl: 'https://192.168.100.103:4000/api/',
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {'Content-Type': 'application/json'},
      ),
    )
    ..interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, ErrorInterceptorHandler handler) {
          if (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.sendTimeout ||
              e.type == DioExceptionType.receiveTimeout) {
            handler.reject(
              DioException(
                requestOptions: e.requestOptions,
                type: DioExceptionType.unknown,
                error: 'Request timed out. Please try again.',
              ),
            );
          } else {
            // Handle other Dio exceptions (e.g., bad response)
            handler.next(e); // Keep default behavior
          }
        },
      ),
    );

  Dio get client => _dio;

  // 🔐 Login
  Future<User> loginUser(String email, String password) async {
    try {
      final response = await _dio.post(
        'auth/login',
        data: {'email': email, 'password': password},
      );
      await TokenOperations().savePrivateKey(response.data['privateKey']);
      return User.fromJson(response.data['user']);
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  // 📝 Register
  Future<User> registerUser(
    String email,
    String password,
    String country,
    String gender,
  ) async {
    try {
      final response = await _dio.post(
        'auth/register',
        data: {
          'email': email,
          'password': password,
          'country': country,
          'gender': gender,
        },
      );
      return User.fromJson(response.data['user']);
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  // ✅ Verify OTP
  Future<User> verifyOTP(
    String email,
    int userId,
    int otp,
    String privateKey,
    String publicKey,
  ) async {
    try {
      final response = await _dio.post(
        'auth/verifyOTP',
        data: {
          'email': email,
          'userId': userId,
          'otp': otp,
          "publicKey": publicKey,
          "privateKey": privateKey,
        },
      );
      return User.fromJson(response.data['user']);
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  // 🔁 Resend OTP
  Future<bool> resendOTP(String email) async {
    try {
      await _dio.post('auth/resendOTP', data: {'email': email});
      return true;
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  // 🔓 Continue with Google (Token-based)
  Future<Map<String, dynamic>> sendGoogleTokensToBackend(String token) async {
    try {
      final response = await _dio.post(
        'auth/continueWithGoogle',
        data: {'token': token},
      );
      if (response.data['privateKey'] != null) {
        await TokenOperations().savePrivateKey(response.data['privateKey']);
      }
      return {
        "user": User.fromJson(response.data['user']),
        "status": response.data['message'],
      };
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  // 🧩 Complete Signup for first-time Google users
  Future<User> completeFirstTimerGoogleSignUp(
    User user,
    String privateKey,
    String publicKey,
  ) async {
    try {
      Map<String, dynamic> userPayload = {
        "email": user.email,
        "password": "GoogleSignUp",
        "userName": user.userName,
        "country": user.country,
        "gender": user.gender,
        "isVerified": true,
        "avatarId": 1,
        "aura": 0,
      };
      final response = await _dio.post(
        'auth/continueWithGoogle/CompletedInfo',
        data: {
          'user': userPayload,
          "publicKey": publicKey,
          "privateKey": privateKey,
        },
      );
      await TokenOperations().savePrivateKey(response.data['privateKey']);

      return User.fromJson(response.data['user']);
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  //Update the avatar of the user
  Future<User> updateAvatar(int userId, int avatarId) async {
    try {
      final response = await _dio.put(
        'user/updateAvatarId',
        data: {'userId': userId, 'avatarId': avatarId},
      );
      return User.fromJson(response.data['user']);
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  //Update the about section of the user
  Future<User> updateAboutSection(int userId, String about) async {
    try {
      final response = await _dio.put(
        'user/updateAboutSection',
        data: {'userId': userId, 'about': about},
      );
      return User.fromJson(response.data['user']);
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<Map<String, dynamic>> getProfile(int myUserId, int otherUserId) async {
    try {
      Map<String, dynamic> profile = {};
      final response = await _dio.get(
        'user/VisitingUser',
        data: {'myUserId': myUserId, 'otherUserId': otherUserId},
      );
      profile['user'] = User.fromJson(response.data['user']);
      profile['isFollowing'] = response.data['isFollowing'];
      return profile;
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  //Follow a user
  Future<void> followingAUser(int myUserId, int otherUserId) async {
    try {
      await _dio.post(
        'user/following',
        data: {'followerId': myUserId, 'followingId': otherUserId},
      );
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  //UnFollow a user
  Future<void> unFollowingAUser(int myUserId, int otherUserId) async {
    try {
      await _dio.delete(
        'user/unfollowing',
        data: {'followerId': myUserId, 'followingId': otherUserId},
      );
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<int> getAura(int userId) async {
    try {
      final response = await _dio.get(
        'user/FetchUpdatedAura',
        data: {'userId': userId},
      );

      return response.data['aura'];
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<Post> uploadPost(
    String title,
    String description,
    String? image,
    String? video,
    bool isDebate,
    int userId,
    List<String>? clusters,
    Uint8List iv,
    String userName,
    int avatarId,
    String? newsId,
    String publicKey,
    bool isAutomatedCluster,
  ) async {
    try {
      final response = await _dio.post(
        'post/uploadPost',
        data: {
          'title': title,
          "description": description,
          "image": image,
          'video': video,
          "isDebate": isDebate,
          "userId": userId,
          "clusters": clusters,
          "userName": userName,
          "avatarId": avatarId,
          "iv": iv,
          "newsId": newsId,
          "publicKey": publicKey,
          "isAutomatedClusters": isAutomatedCluster,
        },
        options: Options(
          sendTimeout: const Duration(minutes: 10),
          receiveTimeout: const Duration(minutes: 10),
        ),
      );

      return Post.fromJson(response.data['post']);
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<List<Post>> fetchUserPosts(
    int ownerUserId,
    int visitingUserId,
    int? lastPostId,
  ) async {
    try {
      final response = await _dio.get(
        'post/getPosts',
        data: {
          'ownerUserId': ownerUserId,
          "visitingUserId": visitingUserId,
          "cursor": lastPostId,
        },
      );

      final List<dynamic> data = response.data['posts'] ?? [];
      return data.map((d) => Post.fromJson(d)).toList();
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<void> updatingVotes(
    int postId,
    int userId,
    bool value,
    BuildContext context,
  ) async {
    bool isAllowedForServer =
        context.read<VotesRestrictorBloc>().state.canVote[postId.toString()] ??
        true;

    if (!isAllowedForServer) {
      return;
    }
    print(isAllowedForServer);

    try {
      await _dio.put(
        'post/updateVotes',
        data: {"postId": postId, "userId": userId, "value": value},
      );
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<List<News>> fetchNews(String country, DateTime date) async {
    try {
      final response = await _dio.get(
        'news/getNews',
        data: {
          "country": country,
          "date": date.toIso8601String().split("T")[0],
        },
      );
      final List<dynamic> data = response.data['news'] ?? [];
      return data.map((d) => News.fromJson(d)).toList();
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<List<Post>> fetchPostsWithInNews(String newsId, int ownerId) async {
    try {
      final response = await _dio.get(
        'post/getPostsWithInNews',
        data: {'newsId': newsId, "ownerId": ownerId},
      );

      final List<dynamic> data = response.data['posts'] ?? [];
      return data.map((d) => Post.fromJson(d)).toList();
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<Map<String, dynamic>> fetchFollowingPosts(
    int userId,
    int? lastPostId,
    List<double>? vector,
    int page,
  ) async {
    try {
      final response = await _dio.get(
        'post/followingPosts',
        data: {
          'userId': userId,
          "cursor": lastPostId,
          "vector": vector,
          "page": page,
        },
      );

      final List<dynamic> data = response.data['posts'] ?? [];
      List<Post> posts = data.map((d) => Post.fromJson(d)).toList();
      List<double>? newVector =
          (response.data['vector'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList();
      Ad? ad =
          response.data['ad'] == null ? null : Ad.fromJson(response.data['ad']);
      return {"posts": posts, "vector": newVector, "ad": ad};
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<Map<String, dynamic>> fetchForYouPosts(
    int userId,
    Map<String, dynamic>? lastPost,
    List<double>? vector,
    int page,
  ) async {
    try {
      final response = await _dio.get(
        'post/forYou',
        data: {
          'userId': userId,
          "lastPost": lastPost,
          "vector": vector,
          "page": page,
        },
      );

      final List<dynamic> data = response.data['posts'] ?? [];
      List<Post> posts = data.map((d) => Post.fromJson(d)).toList();
      List<double>? newVector =
          (response.data['vector'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList();
      Ad? ad =
          response.data['ad'] == null ? null : Ad.fromJson(response.data['ad']);
      Map<String, dynamic>? lastForYou = response.data['lastPost'];
      return {
        "posts": posts,
        "vector": newVector,
        "ad": ad,
        "lastPost": lastForYou,
      };
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<Map<String, dynamic>> fetchTrendingPosts(
    int userId,
    List<double>? vector,
    int page,
  ) async {
    try {
      final response = await _dio.get(
        'post/trendingPost',
        data: {'userId': userId, "vector": vector, "page": page},
      );

      final List<dynamic> data = response.data['posts'] ?? [];
      List<Post> posts = data.map((d) => Post.fromJson(d)).toList();
      List<double>? newVector =
          (response.data['vector'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList();
      Ad? ad =
          response.data['ad'] == null ? null : Ad.fromJson(response.data['ad']);
      return {"posts": posts, "vector": newVector, "ad": ad};
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<void> registerClick(int postId, int userId) async {
    try {
      await _dio.post(
        'post/registerClick',
        data: {"postId": postId, "userId": userId},
      );
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<List<Post>> searchSimilarPosts(
    int userId,
    String title,
    String description,
  ) async {
    try {
      final response = await _dio.get(
        'post/searchSimilarPosts',
        data: {'userId': userId, "title": title, "description": description},
      );

      final List<dynamic> data = response.data['posts'] ?? [];
      List<Post> posts = data.map((d) => Post.fromJson(d)).toList();
      return posts;
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<int> resetPasswordStep1(String email) async {
    try {
      final response = await _dio.post(
        'auth/resetPassword',
        data: {'email': email},
      );
      return response.data['token'];
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<int> resetPasswordStep2(String email, int token, String otp) async {
    try {
      final response = await _dio.post(
        'auth/resetPassword/verifyOTP',
        data: {'email': email, "token": token, "otp": otp},
      );

      return response.data['token'];
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<void> resetPasswordStep3(String email, int userId, password) async {
    try {
      await _dio.put(
        'auth/resetPassword/verifyOTP/newPassword',
        data: {'userId': userId, "email": email, "password": password},
      );
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<void> resetprefrences(int userId) async {
    try {
      await _dio.delete('user/deleteHistory', data: {'userId': userId});
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<List<Chat>> fetchUserChats(int userId) async {
    try {
      final response = await _dio.get(
        'chat/getUserChats',
        data: {'userId': userId},
      );

      final List<dynamic> data = response.data['chats'] ?? [];
      List<Chat> chats = data.map((d) => Chat.fromJson(d)).toList();
      return chats;
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<Chat?> checkAndFetchChat(int user1Id, int user2Id) async {
    try {
      final response = await _dio.get(
        'chat/getChatWithAUser',
        data: {'user1Id': user1Id, 'user2Id': user2Id},
      );

      return response.data['chat'] == null
          ? null
          : Chat.fromJson(response.data['chat']);
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<Chat> createChat(Chat chat) async {
    try {
      final data = {
        // keep list of ints as-is
        'participantIds': chat.participantIds,

        // convert map keys only (int → string)
        'publicKeys': chat.publicKeys.map(
          (key, value) => MapEntry(key.toString(), value),
        ),
        'userProfiles': chat.userProfiles.map(
          (key, value) => MapEntry(key.toString(), value),
        ),
        'userNames': chat.userNames.map(
          (key, value) => MapEntry(key.toString(), value),
        ),
        'lastMessageSeenBy': chat.lastMessageSeenBy.map(
          (key, value) => MapEntry(key.toString(), value),
        ),
      };
      final response = await _dio.post('chat/insertChat', data: data);

      return Chat.fromJson(response.data['chat']);
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<void> sendingMessage(
    Message message,
    String chatId,
    String receiverId,
    String messageId,
    DateTime createdAt,
  ) async {
    try {
      await _dio.post(
        'message/sendMessage',
        data: {
          'chatId': chatId,
          'message': message.message,
          'sentBy': message.sentBy,
          'replyingMessageId': message.replyMessage.messageId,
          'reaction': null,
          "receiverId": receiverId,
          'messageId': messageId,
          'createdAt': createdAt.toUtc().toIso8601String(),
        },
      );
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<void> seenAck(String chatId, String userId, String receiverId) async {
    try {
      await _dio.put(
        'message/updateSeenStatus',
        data: {'chatId': chatId, 'userId': userId, "receiverId": receiverId},
      );
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<List<Message>> fetchMessages(String chatId, DateTime before) async {
    try {
      final response = await _dio.get(
        'message/getMessages',
        data: {'chatId': chatId, "before": before.toUtc().toIso8601String()},
      );

      final List<dynamic> data = response.data['messages'] ?? [];
      List<Message> messages = data.map((d) => Message.fromJson(d)).toList();
      messages =
          messages.map((m) {
            return m.copyWith(createdAt: m.createdAt.toLocal());
          }).toList();
      return messages;
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<List<Message>> updateMessage(
    String messageId,
    Map<String, String> reaction,
    String notifyingUserId,
  ) async {
    try {
      final response = await _dio.put(
        'message/updateMessage',
        data: {
          'messageId': messageId,
          "reaction": reaction,
          "notifyUserId": notifyingUserId,
        },
      );

      final List<dynamic> data = response.data['messages'] ?? [];
      List<Message> messages = data.map((d) => Message.fromJson(d)).toList();
      messages =
          messages.map((m) {
            return m.copyWith(createdAt: m.createdAt.toLocal());
          }).toList();
      return messages;
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<void> deleteChat(String chatId) async {
    try {
      await _dio.delete('chat/deleteChat', data: {'chatId': chatId});
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<Chat> fetchChat(String chatId) async {
    try {
      final response = await _dio.get('chat/getChat', data: {'chatId': chatId});

      return Chat.fromJson(response.data['chat']);
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<List<Comment>> fetchUserComments(
    int visitingUserId,
    int ownerUserId,
  ) async {
    try {
      final response = await _dio.get(
        'comment/getComments',
        data: {'visitingUserId': visitingUserId, "ownerUserId": ownerUserId},
      );

      final List<dynamic> data = response.data['comments'] ?? [];
      List<Comment> comments = data.map((d) => Comment.fromJson(d)).toList();
      return comments;
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<List<Comment>> fetchPostComments(
    int userId,
    String postId,
    DateTime? before,
  ) async {
    try {
      final response = await _dio.get(
        'comment/getCommentsOfPost',
        data: {
          'userId': userId,
          "postId": postId,
          "before": before?.toUtc().toIso8601String(),
        },
      );

      final List<dynamic> data = response.data['comments'] ?? [];
      List<Comment> comments = data.map((d) => Comment.fromJson(d)).toList();
      return comments;
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<Comment> uploadComment(
    String postId,
    String titleOfThePost,
    String text,
    String author,
    int profile,
    String commenterGender,
    String commenterCountry,
    String? parentId,
    List<String>? clusters,
    DateTime uploadTime,
    int userId,
    Uint8List iv,
    String? parentComment,
    int? parentCommentUserId,
    String descriptionOfThePost,
    bool isAutomatedClusters,
  ) async {
    try {
      final response = await _dio.post(
        'comment/addComment',
        data: {
          'postId': postId,
          "titleOfThePost": titleOfThePost,
          "text": text,
          'author': author,
          "profile": profile,
          "userId": userId,
          "clusters": clusters,
          "commenterGender": commenterGender,
          "commenterCountry": commenterCountry,
          "iv": iv,
          "parentId": parentId,
          "uploadTime": uploadTime.toUtc().toIso8601String(),
          "parentComment": parentComment,
          "parentCommentUserId": parentCommentUserId,
          "descriptionOfThePost": descriptionOfThePost,
          "isAutomatedCluster": isAutomatedClusters,
        },
      );

      return Comment.fromJson(response.data['comment']);
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<List<Comment>> fetchClusterComments(
    int userId,
    String postId,
    String clusterName,
  ) async {
    try {
      final response = await _dio.get(
        'comment/getClusterComments',
        data: {'userId': userId, "postId": postId, "clusterName": clusterName},
      );

      final List<dynamic> data = response.data['comments'] ?? [];
      List<Comment> comments = data.map((d) => Comment.fromJson(d)).toList();
      return comments;
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<void> updatingCommmentsVote(
    String commentId,
    int userId,
    String type,
    BuildContext context,
  ) async {
    bool isAllowedForServer =
        context.read<VotesRestrictorBloc>().state.canVote[commentId] ?? true;

    if (!isAllowedForServer) {
      return;
    }

    try {
      await _dio.put(
        'comment/updateVote',
        data: {"commentId": commentId, "userId": userId, "type": type},
      );
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<CommentStats> fetchPostStats(int postId, List<String> clusters) async {
    try {
      final response = await _dio.get(
        'comment/getTotalClusterInfo',
        data: {"postId": postId, "clusters": clusters},
      );

      return CommentStats.fromJson(response.data);
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<AnalyticsData> fetchClusterAnalytics(
    int postId,
    String cluster,
  ) async {
    try {
      final response = await _dio.get(
        'comment/getAnalytics',
        data: {"postId": postId, "cluster": cluster},
      );

      return AnalyticsData.fromJson(response.data);
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<Summary?> fetchSummary(String postId) async {
    try {
      final response = await _dio.get(
        'summary/summary',
        data: {"postId": postId},
      );
      return response.data['summary'] == null
          ? null
          : Summary.fromJson(response.data['summary']);
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<List<User>> searchUsers(String userName) async {
    try {
      final response = await _dio.get(
        'user/users',
        data: {"userName": userName},
      );
      final List<dynamic> data = response.data['users'] ?? [];
      List<User> users = data.map((d) => User.fromJson(d)).toList();
      return users;
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<List<Post>> searchedPosts(String query, int userId) async {
    try {
      final response = await _dio.get(
        'post/searchedPosts',
        data: {"query": query, "userId": userId},
      );
      final List<dynamic> data = response.data['posts'] ?? [];
      List<Post> posts = data.map((d) => Post.fromJson(d)).toList();
      return posts;
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<List<Post>> getSavedPosts(int userId) async {
    try {
      final response = await _dio.get(
        'post/savePost',
        data: {"userId": userId},
      );
      final List<dynamic> data = response.data['posts'] ?? [];
      List<Post> posts = data.map((d) => Post.fromJson(d)).toList();
      return posts;
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<String> savePost(int userId, int postId) async {
    try {
      final response = await _dio.post(
        'post/savePost',
        data: {
          "userId": userId,
          "postId": postId,
          "savedAt": DateTime.now().toUtc().toIso8601String(),
        },
      );

      return response.data['status'];
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<void> unsave(int userId, int postId) async {
    try {
      await _dio.delete(
        'post/savePost',
        data: {"userId": userId, "postId": postId},
      );
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<void> deletePost(int postId) async {
    try {
      await _dio.delete('post/post', data: {"postId": postId});
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<List<AppNotification>> getNotifications(int userId) async {
    try {
      final response = await _dio.get(
        'notification/getNotification',
        data: {"userId": userId},
      );
      final List<dynamic> data = response.data['notifications'] ?? [];
      List<AppNotification> notifications =
          data.map((d) => AppNotification.fromJson(d)).toList();
      return notifications;
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<List<Report>> getReports(int userId) async {
    try {
      final response = await _dio.get(
        'report/fetchReports',
        data: {"userId": userId},
      );
      final List<dynamic> data = response.data['reports'] ?? [];
      List<Report> reports = data.map((d) => Report.fromJson(d)).toList();
      return reports;
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<Report?> addReport(
    int reporterUserId,
    bool isPostReport,
    bool isCommentReport,
    bool isUserReport,
    String? postId,
    String? commentId,
    int? reportedUserId,
    String reportContent,
  ) async {
    try {
      final response = await _dio.post(
        'report/uploadReport',
        data: {
          'reporterUserId': reporterUserId,
          "isPostReport": isPostReport,
          "isCommentReport": isCommentReport,
          'isUserReport': isUserReport,
          "postId": postId,
          "commentId": commentId,
          "reportedUserId": reportedUserId,
          "reportContent": reportContent,
          "reportTime": DateTime.now().toUtc().toIso8601String(),
        },
      );

      return Report.fromJson(response.data['report']);
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  void markAsRead(List<int> notificationIds) async {
    try {
      await _dio.put(
        'notification/markAsReadNotification',
        data: {'notificationIds': notificationIds},
      );
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  Future<Post> fetchPostWithId(String id, int userId) async {
    try {
      final result = await _dio.get(
        'post/post',
        data: {'postId': id, "userId": userId},
      );
      return Post.fromJson(result.data["post"]);
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  void deleteNotification(List<int> notificationIds) async {
    try {
      await _dio.delete(
        'notification/notifications',
        data: {'notificationIds': notificationIds},
      );
    } on DioException catch (e) {
      final errorMessage = _extractErrorMessage(e);
      throw Exception(errorMessage);
    }
  }

  String _extractErrorMessage(DioException e) {
    if (e.response?.data != null) {
      final data = e.response!.data;
      if (data is Map<String, dynamic> && data.containsKey('error')) {
        return data['error'].toString();
      }
    }

    if (e.error != null && e.error is String) {
      return e.error as String;
    }

    return "Something went wrong. Please try again.";
  }
}
