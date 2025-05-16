// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import 'package:verbatica/Utilities/Color.dart';

import 'package:verbatica/model/news.dart';

class NewsView extends StatelessWidget {
  final News news;
  final int index;

  const NewsView({super.key, required this.index, required this.news});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: news.image,

              placeholder:
                  (context, url) => Shimmer.fromColors(
                    baseColor: const Color.fromARGB(255, 58, 76, 90),
                    highlightColor: const Color.fromARGB(255, 81, 106, 125),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(color: Colors.white),
                    ),
                  ),
              errorWidget:
                  (context, url, error) => AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.error),
                    ),
                  ),
              fit: BoxFit.contain,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    news.description,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 193, 192, 192),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final uri = Uri.parse(news.url);
                          if (!await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          )) {
                            throw 'Could not launch ${news.url}';
                          }
                        },
                        child: Text(
                          news.sourceName,
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                      Text(
                        timeago.format(news.publishedAt),
                        style: TextStyle(
                          color: const Color.fromARGB(255, 201, 200, 200),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
