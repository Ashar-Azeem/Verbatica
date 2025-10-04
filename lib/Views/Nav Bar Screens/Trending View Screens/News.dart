// ignore_for_file: file_names
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/Trending%20View%20Screens/PostsWithInNews.dart';

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
      color: Theme.of(context).cardColor,
      child: InkWell(
        onTap: () {
          pushScreen(
            context,
            screen: PostsWithInNews(news: news, newsIndex: index),
            withNavBar: true,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: news.image,
              placeholder:
                  (context, url) => Shimmer.fromColors(
                    baseColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(
                              context,
                            ).colorScheme.surface.withOpacity(0.3)
                            : Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest
                                .withOpacity(0.3),
                    highlightColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(
                              context,
                            ).colorScheme.surface.withOpacity(0.6)
                            : Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest
                                .withOpacity(0.6),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
              errorWidget: (context, url, error) => SizedBox.shrink(),
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
                      color: Theme.of(context).textTheme.headlineSmall?.color,
                    ),
                  ),
                  SizedBox(height: 6),
                  ExpandableText(
                    news.description,
                    expandOnTextTap: true,
                    collapseOnTextTap: true,
                    expandText: 'show more',
                    collapseText: 'show less',
                    linkEllipsis: false,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 3.8.w,
                      color: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.color?.withOpacity(0.8),
                      fontWeight: FontWeight.w300,
                    ),
                    linkColor: Theme.of(context).colorScheme.primary,
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
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      Text(
                        timeago.format(news.publishedAt),
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).textTheme.bodySmall?.color?.withOpacity(0.7),
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
