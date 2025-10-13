import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbatica/BLOC/Votes%20Restriction/votes_restrictor_bloc.dart';
import 'package:verbatica/LocalDB/TokenOperations.dart';
import 'package:verbatica/model/Ad.dart';
import 'package:verbatica/model/Post.dart';
import 'package:verbatica/model/news.dart';
import 'package:verbatica/model/user.dart';

class ApiService {
  final Dio _dio = Dio(
      BaseOptions(
        baseUrl: 'http://192.168.1.8:4000/api/',
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

  // 🔎 Extract error message helper
  String _extractErrorMessage(DioException e) {
    if (e.response?.data != null) {
      final data = e.response!.data;
      if (data is Map<String, dynamic> && data.containsKey('error')) {
        return data['error'].toString();
      }
    }

    // 👇 Handle custom errors like timeouts from interceptor
    if (e.error != null && e.error is String) {
      return e.error as String;
    }

    return "Something went wrong. Please try again.";
  }
}
