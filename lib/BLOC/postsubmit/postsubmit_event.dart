import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:verbatica/model/Post.dart'; // Your Post model

// Events
class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

class SubmitPostEvent extends PostEvent {
  final Post post;
  final File? image;
  final File? video;
  final String? newsId;
  final BuildContext context;
  const SubmitPostEvent(
    this.post,
    this.image,
    this.video,
    this.context,
    this.newsId,
  );
}

class CompressedProgress extends PostEvent {
  final String progress;

  const CompressedProgress(this.progress);
}
