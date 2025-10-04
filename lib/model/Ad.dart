// ignore_for_file: file_names

import 'package:equatable/equatable.dart';

class Ad extends Equatable {
  final int adId;
  final String title;
  final String description;
  final String? imageUrl;
  final String? videoUrl;
  final String redirectLink;

  const Ad({
    required this.adId,
    required this.title,
    required this.description,
    this.imageUrl,
    this.videoUrl,
    required this.redirectLink,
  });

  Map<String, dynamic> toJson() {
    return {
      'ad_id': adId,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'video_url': videoUrl,
      'redirect_link': redirectLink,
    };
  }

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      adId: json['ad_id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      videoUrl: json['video_url'],
      redirectLink: json['redirect_link'],
    );
  }

  Ad copyWith({
    int? adId,
    String? title,
    String? description,
    String? imageUrl,
    String? videoUrl,
    String? redirectLink,
  }) {
    return Ad(
      adId: adId ?? this.adId,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      redirectLink: redirectLink ?? this.redirectLink,
    );
  }

  @override
  List<Object?> get props => [
    adId,
    title,
    description,
    imageUrl,
    videoUrl,
    redirectLink,
  ];
}
