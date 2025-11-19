import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:fullscreen_image_viewer/fullscreen_image_viewer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verbatica/UI_Components/PostComponents/VideoPlayer.dart';
import 'package:verbatica/model/Ad.dart';

class AdCard extends StatelessWidget {
  final Ad ad;

  const AdCard({super.key, required this.ad});

  Future<void> _launchAdLink(String url) async {
    final uri = Uri.parse(ad.redirectLink);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch ${ad.redirectLink}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 3,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.only(left: 1.w, top: 1.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(ad.brandAvatarLocation),
                ),
                const SizedBox(width: 10),
                Text(
                  ad.brandName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(right: 3.w),
                  child: Text(
                    "AD",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.w),

            /// AD TITLE
            Text(
              ad.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 0.5.w),

            Padding(
              padding: EdgeInsets.only(left: 1.w),
              child: ExpandableText(
                ad.description,
                expandOnTextTap: true,
                collapseOnTextTap: true,
                expandText: 'show more',
                collapseText: 'show less',
                linkEllipsis: false,
                maxLines: 6,
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                linkColor: colorScheme.primary,
              ),
            ),

            const SizedBox(height: 10),

            if (ad.imageUrl != null)
              GestureDetector(
                onTap: () async {
                  await FullscreenImageViewer.open(
                    context: context,
                    child: CachedNetworkImage(
                      imageUrl: ad.imageUrl!,
                      placeholder:
                          (context, url) => Shimmer.fromColors(
                            baseColor: colorScheme.surfaceContainerHighest,
                            highlightColor: colorScheme.surfaceContainerHighest
                                .withOpacity(0.8),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Container(color: colorScheme.surface),
                            ),
                          ),
                      errorWidget:
                          (context, url, error) => AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              color: colorScheme.errorContainer,
                              child: Icon(
                                Icons.error,
                                color: colorScheme.onErrorContainer,
                              ),
                            ),
                          ),
                      fit: BoxFit.contain,
                    ),
                  );
                },
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: ad.imageUrl!,
                    placeholder:
                        (context, url) => Shimmer.fromColors(
                          baseColor: colorScheme.surfaceContainerHighest,
                          highlightColor: colorScheme.surfaceContainerHighest
                              .withOpacity(0.8),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(color: colorScheme.surface),
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                            color: colorScheme.errorContainer,
                            child: Icon(
                              Icons.error,
                              color: colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            if (ad.videoUrl != null)
              BetterCacheVideoPlayer(videoUrl: ad.videoUrl),

            const SizedBox(height: 5),

            Padding(
              padding: EdgeInsets.only(bottom: 0.5.h, left: 1.w, right: 1.w),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _launchAdLink(ad.redirectLink),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF00D4FF), // bright cyan
                        Color(0xFF33A6FF), // balanced mid blue
                        Color(0xFF3378FF), // rich medium blue
                        Color.fromARGB(255, 0, 106, 255), // deep royal blue
                      ],
                      stops: [0.0, 0.35, 0.7, 1.0],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x330056FF),
                        blurRadius: 6,
                        offset: Offset(2, 3),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Click to visit this ad",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
