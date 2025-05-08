// ignore_for_file: file_names
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayer extends StatefulWidget {
  final String videoUrl;
  const VideoPlayer({super.key, required this.videoUrl});

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();

    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );
    _videoController.initialize().then((value) {
      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: _videoController,
          autoPlay: false,
          looping: false,
          allowFullScreen: true,
          deviceOrientationsOnEnterFullScreen: [
            DeviceOrientation.portraitUp,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ],
          showControlsOnInitialize: false, // No controls on start
          deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
          fullScreenByDefault: false,
        );
      });
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.videoUrl),
      onVisibilityChanged: (info) {
        // Pause if less than 50% visible
        if (info.visibleFraction < 0.5 && _videoController.value.isPlaying) {
          _videoController.pause();
        }
        //Resumes if greater then 50% visibility
        else if (info.visibleFraction >= 0.5 &&
            !_videoController.value.isPlaying) {
          _videoController.play();
        }
      },
      child:
          _chewieController != null && _videoController.value.isInitialized
              ? AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: Chewie(controller: _chewieController!),
              )
              : Container(
                color: Color.fromARGB(255, 35, 44, 51),
                height: 25.h,
                width: 100.w,
                child: Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.white,
                    size: 10.w,
                  ),
                ),
              ),
    );
  }
}
