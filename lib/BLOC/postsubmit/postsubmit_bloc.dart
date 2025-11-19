// BLoC
import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbatica/BLOC/Trending%20View%20BLOC/trending_view_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_event.dart';
import 'package:verbatica/BLOC/postsubmit/postsubmit_event.dart';
import 'package:verbatica/BLOC/postsubmit/postsubmit_state.dart';
import 'package:verbatica/Services/API_Service.dart';
import 'package:verbatica/Utilities/compressors.dart';
import 'package:verbatica/Services/encryption.dart';
import 'package:verbatica/model/Post.dart';
import 'package:video_compress/video_compress.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(const PostState()) {
    VideoCompress.compressProgress$.subscribe((progress) {
      add(CompressedProgress(progress.toInt().toString()));
    });
    on<SubmitPostEvent>(_submitPost);
    on<CompressedProgress>(progress);
    on<CheckSimilar>(checkSimilar);
    on<UpVoteSimilarPosts>(upVoteSimilarPosts);
    on<DownVoteSimilarPosts>(downVoteSimilarPosts);
    on<UpdateCommentCountOfAPostInSimilarPosts>((event, emit) {
      List<Post> posts = List.from(state.similarPosts);
      posts[event.postIndex] = posts[event.postIndex].copyWith(
        comments: posts[event.postIndex].comments + 1,
      );
      emit(state.copyWith(similarPosts: posts));
    });
  }

  void progress(CompressedProgress event, Emitter<PostState> emit) {
    emit(state.copyWith(progress: event.progress));
  }

  Future<void> checkSimilar(CheckSimilar event, Emitter<PostState> emit) async {
    try {
      emit(
        state.copyWith(
          status: PostStatus.checkingDuplicates,
          loading: true,
          similarPosts: [],
          currentScreen: event.currentScreen,
        ),
      );
      //Checking for the duplicates
      List<Post> similarPosts = await ApiService().searchSimilarPosts(
        event.userId,
        event.title,
        event.description,
      );
      emit(state.copyWith(loading: false, similarPosts: similarPosts));
    } catch (e) {
      emit(
        state.copyWith(
          error: e.toString(),
          status: PostStatus.error,
          loading: false,
        ),
      );
    }
  }

  Future<void> _submitPost(
    SubmitPostEvent event,
    Emitter<PostState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          similarPosts: [],
          loading: true,
          currentScreen: event.currentScreen,
        ),
      );

      //uploading to the server with a picture
      if (event.image != null) {
        emit(state.copyWith(status: PostStatus.preparingImage));
        //compressing the image
        File image = await compressImage(event.image!);

        //Encrypting the post data
        emit(state.copyWith(status: PostStatus.encrypting));
        final iv = generateRandomIVBytes();
        final encryptedTitle = encryptText(event.post.title, aesKey, iv);
        final encryptedDescription = encryptText(
          event.post.description,
          aesKey,
          iv,
        );
        final fileBytes = await image.readAsBytes();
        final encryptedMediaBytes = encryptBytes(fileBytes, aesKey, iv);

        emit(state.copyWith(status: PostStatus.uploadingToTheServer));
        //uploading to the server

        Post post = await ApiService().uploadPost(
          encryptedTitle,
          encryptedDescription,
          encryptedMediaBytes,
          null,
          event.post.isDebate,
          event.post.userId,
          event.post.clusters,
          iv,
          event.post.name,
          event.post.avatar,
          event.newsId,
          event.context.read<UserBloc>().state.user!.publicKey,
        );

        event.context.read<UserBloc>().add(AddRecentPost(post: post));
        if (event.newsId != null) {
          event.context.read<TrendingViewBloc>().add(
            AddRecentPostInNews(event.newsId!, post: post),
          );
        }

        //Done
        emit(state.copyWith(status: PostStatus.done, loading: false));
      }
      //uploading to the server with a video
      else if (event.video != null) {
        emit(state.copyWith(status: PostStatus.preparingVideo));
        File video = await compressVideo(event.video!);

        //Encrypting the post data
        emit(state.copyWith(status: PostStatus.encrypting));
        final iv = generateRandomIVBytes();
        final encryptedTitle = encryptText(event.post.title, aesKey, iv);
        final encryptedDescription = encryptText(
          event.post.description,
          aesKey,
          iv,
        );
        final fileBytes = await video.readAsBytes();
        final encryptedMediaBytes = await encryptInIsolate(
          EncryptionParams(fileBytes, aesKey, iv),
        );

        emit(state.copyWith(status: PostStatus.uploadingToTheServer));
        //uploading to the server

        Post post = await ApiService().uploadPost(
          encryptedTitle,
          encryptedDescription,
          null,
          encryptedMediaBytes,
          event.post.isDebate,
          event.post.userId,
          event.post.clusters,
          iv,
          event.post.name,
          event.post.avatar,
          event.newsId,
          event.context.read<UserBloc>().state.user!.publicKey,
        );

        event.context.read<UserBloc>().add(AddRecentPost(post: post));
        if (event.newsId != null) {
          event.context.read<TrendingViewBloc>().add(
            AddRecentPostInNews(event.newsId!, post: post),
          );
        }
        //Done
        emit(state.copyWith(status: PostStatus.done, loading: false));
        return;
      }
      //Uploading a text post to the server
      else {
        //Encrypting the post data
        emit(state.copyWith(status: PostStatus.encrypting));
        final iv = generateRandomIVBytes();
        final encryptedTitle = encryptText(event.post.title, aesKey, iv);
        final encryptedDescription = encryptText(
          event.post.description,
          aesKey,
          iv,
        );

        emit(state.copyWith(status: PostStatus.uploadingToTheServer));
        //uploading to the server
        Post post = await ApiService().uploadPost(
          encryptedTitle,
          encryptedDescription,
          null,
          null,
          event.post.isDebate,
          event.post.userId,
          event.post.clusters,
          iv,
          event.post.name,
          event.post.avatar,
          event.newsId,
          event.context.read<UserBloc>().state.user!.publicKey,
        );

        event.context.read<UserBloc>().add(AddRecentPost(post: post));
        if (event.newsId != null) {
          event.context.read<TrendingViewBloc>().add(
            AddRecentPostInNews(event.newsId!, post: post),
          );
        }
        //Done
        emit(state.copyWith(status: PostStatus.done, loading: false));
      }
    } catch (e) {
      print(e);
      emit(
        state.copyWith(
          loading: false,
          status: PostStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  void upVoteSimilarPosts(UpVoteSimilarPosts event, Emitter<PostState> emit) {
    List<Post> posts = List.from(state.similarPosts);
    ApiService().updatingVotes(
      int.parse(posts[event.index].id),
      event.context.read<UserBloc>().state.user!.id,
      true,
      event.context,
    );
    if (!posts[event.index].isUpVote) {
      if (posts[event.index].isDownVote) {
        posts[event.index] = posts[event.index].copyWith(
          isDownVote: false,
          isUpVote: true,
          upvotes: posts[event.index].upvotes + 2,
        );
        emit(state.copyWith(similarPosts: posts));
      } else {
        posts[event.index] = posts[event.index].copyWith(
          isUpVote: true,
          upvotes: posts[event.index].upvotes + 1,
        );
        emit(state.copyWith(similarPosts: posts));
      }
    } else {
      //undo the vote
      posts[event.index] = posts[event.index].copyWith(
        isDownVote: false,
        isUpVote: false,
        upvotes: posts[event.index].upvotes - 1,
      );
      emit(state.copyWith(similarPosts: posts));
    }
  }

  void downVoteSimilarPosts(
    DownVoteSimilarPosts event,
    Emitter<PostState> emit,
  ) {
    List<Post> posts = List.from(state.similarPosts);
    ApiService().updatingVotes(
      int.parse(posts[event.index].id),
      event.context.read<UserBloc>().state.user!.id,
      false,
      event.context,
    );
    if (!posts[event.index].isDownVote) {
      if (posts[event.index].isUpVote) {
        posts[event.index] = posts[event.index].copyWith(
          isDownVote: true,
          isUpVote: false,
          upvotes: posts[event.index].upvotes - 2,
        );
        emit(state.copyWith(similarPosts: posts));
      } else {
        posts[event.index] = posts[event.index].copyWith(
          isDownVote: true,
          upvotes: posts[event.index].upvotes - 1,
        );
        emit(state.copyWith(similarPosts: posts));
      }
    } else {
      //undo the vote
      posts[event.index] = posts[event.index].copyWith(
        isDownVote: false,
        isUpVote: false,
        downvotes: posts[event.index].downvotes - 1,
      );
      emit(state.copyWith(similarPosts: posts));
    }
  }
}
