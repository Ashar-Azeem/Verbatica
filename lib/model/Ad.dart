// ignore_for_file: file_names

import 'package:equatable/equatable.dart';
import 'package:verbatica/model/FeedItem.dart';

class Ad extends Equatable implements FeedItem {
  final int adId;
  final String title;
  final String description;
  final String? imageUrl;
  final String? videoUrl;
  final String redirectLink;
  final String brandName;
  final String brandAvatarLocation;

  const Ad({
    required this.adId,
    required this.title,
    required this.description,
    this.imageUrl,
    this.videoUrl,
    required this.redirectLink,
    required this.brandName,
    required this.brandAvatarLocation,
  });

  Map<String, dynamic> toJson() {
    return {
      'ad_id': adId,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'video_url': videoUrl,
      'redirect_link': redirectLink,
      'brand_name': brandName,
      'brand_avatar_location': brandAvatarLocation,
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
      brandName: json['brand_name'],
      brandAvatarLocation: json['brand_avatar_location'],
    );
  }

  Ad copyWith({
    int? adId,
    String? title,
    String? description,
    String? imageUrl,
    String? videoUrl,
    String? redirectLink,
    String? brandName,
    String? brandAvatarLocation,
  }) {
    return Ad(
      adId: adId ?? this.adId,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      redirectLink: redirectLink ?? this.redirectLink,
      brandName: brandName ?? this.brandName,
      brandAvatarLocation: brandAvatarLocation ?? this.brandAvatarLocation,
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
    brandName,
    brandAvatarLocation,
  ];
}
