// BLoC
import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_event.dart';
import 'package:verbatica/BLOC/postsubmit/postsubmit_event.dart';
import 'package:verbatica/BLOC/postsubmit/postsubmit_state.dart';
import 'package:verbatica/Services/API_Service.dart';
import 'package:verbatica/Utilities/compressors.dart';
import 'package:verbatica/Utilities/encryption.dart';
import 'package:verbatica/model/Post.dart';
import 'package:video_compress/video_compress.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(const PostState()) {
    VideoCompress.compressProgress$.subscribe((progress) {
      add(CompressedProgress(progress.toInt().toString()));
    });
    on<SubmitPostEvent>(_submitPost);
    on<CompressedProgress>(progress);
  }

  void progress(CompressedProgress event, Emitter<PostState> emit) {
    emit(state.copyWith(progress: event.progress));
  }

  Future<void> _submitPost(
    SubmitPostEvent event,
    Emitter<PostState> emit,
  ) async {
    try {
      emit(
        state.copyWith(status: PostStatus.checkingDuplicates, loading: true),
      );
      //Checking for the duplicates
      await Future.delayed(Duration(seconds: 2));

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
        );

        event.context.read<UserBloc>().add(AddRecentPost(post: post));

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
        );

        event.context.read<UserBloc>().add(AddRecentPost(post: post));
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
        );

        event.context.read<UserBloc>().add(AddRecentPost(post: post));

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
}
