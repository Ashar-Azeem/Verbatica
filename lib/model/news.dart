import 'package:equatable/equatable.dart';
import 'package:verbatica/model/Post.dart';

class News extends Equatable {
  final String newsId;
  final String title;
  final String description;
  final String url;
  final String image;
  final DateTime publishedAt;
  final String sourceName;
  final String sourceUrl;
  final List<Post> discussions;

  const News({
    required this.newsId,
    required this.title,
    required this.description,
    required this.url,
    required this.image,
    required this.publishedAt,
    required this.sourceName,
    required this.sourceUrl,
    required this.discussions,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      newsId: json['newsId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      url: json['url'] as String,
      image: json['image'] as String,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      sourceName: json['source']['name'] as String,
      sourceUrl: json['source']['url'] as String,
      discussions:
          (json['discussions'] as List<dynamic>)
              .map((e) => Post.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'newsId': newsId,
      'title': title,
      'description': description,
      'url': url,
      'image': image,
      'publishedAt': publishedAt.toIso8601String(),
      'source': {'name': sourceName, 'url': sourceUrl},
      'discussions': discussions.map((post) => post.toJson()).toList(),
    };
  }

  News copyWith({
    String? newsId,
    String? title,
    String? description,
    String? url,
    String? image,
    DateTime? publishedAt,
    String? sourceName,
    String? sourceUrl,
    List<Post>? discussions,
  }) {
    return News(
      newsId: newsId ?? this.newsId,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      image: image ?? this.image,
      publishedAt: publishedAt ?? this.publishedAt,
      sourceName: sourceName ?? this.sourceName,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      discussions: discussions ?? this.discussions,
    );
  }

  @override
  List<Object?> get props => [
    newsId,
    title,
    description,
    url,
    image,
    publishedAt,
    sourceName,
    sourceUrl,
    discussions,
  ];
}
