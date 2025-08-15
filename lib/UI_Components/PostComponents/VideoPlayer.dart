import 'dart:io';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:visibility_detector/visibility_detector.dart';

class BetterCacheVideoPlayer extends StatefulWidget {
  final String? videoUrl;
  final File? videoFileLocation;

  const BetterCacheVideoPlayer({
    super.key,
    this.videoUrl,
    this.videoFileLocation,
  });

  @override
  State createState() => _BetterCacheVideoPlayerState();
}

class _BetterCacheVideoPlayerState extends State<BetterCacheVideoPlayer> {
  BetterPlayerController? _betterController;
  double _aspectRatio = 16 / 9; // default before video loads

  @override
  void initState() {
    super.initState();

    BetterPlayerDataSource dataSource;
    if (widget.videoUrl != null) {
      dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.videoUrl!,
        cacheConfiguration: BetterPlayerCacheConfiguration(
          useCache: true,
          key: widget.videoUrl!, // ensures reuse across sessions
        ),
      );
    } else {
      dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.file,
        widget.videoFileLocation!.path,
      );
    }

    _betterController = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: false,
        looping: false,
        fullScreenByDefault: false,
        allowedScreenSleep: false,
        fit: BoxFit.contain,
        aspectRatio: _aspectRatio,
        controlsConfiguration: BetterPlayerControlsConfiguration(),
      ),
      betterPlayerDataSource: dataSource,
    );

    // Listen for when the video is initialized
    _betterController!.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
        final videoAspectRatio =
            _betterController!.videoPlayerController!.value.aspectRatio;
        setState(() {
          _aspectRatio = videoAspectRatio;
          // If portrait, fill height (cover); if landscape, keep contain
          //aspect ratio = width/height => height greater so potrait then covers the whole video meaning the display is now potrait
          if (videoAspectRatio < 1) {
            _betterController!.setOverriddenFit(BoxFit.cover);
            _betterController!.setOverriddenAspectRatio(videoAspectRatio);
          } else {
            _betterController!.setOverriddenFit(BoxFit.contain);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _betterController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return VisibilityDetector(
      key: Key(widget.videoUrl ?? widget.videoFileLocation!.path),
      onVisibilityChanged: (info) {
        if (info.visibleFraction < 0.5 &&
            _betterController?.isPlaying() == true) {
          _betterController?.pause();
        }
      },
      child:
          _betterController != null
              ? AspectRatio(
                aspectRatio: _aspectRatio,
                child: BetterPlayer(controller: _betterController!),
              )
              : Container(
                color: theme.scaffoldBackgroundColor,
                height: 25.h,
                width: 100.w,
                child: Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: theme.colorScheme.onSurface,
                    size: 10.w,
                  ),
                ),
              ),
    );
  }
}
