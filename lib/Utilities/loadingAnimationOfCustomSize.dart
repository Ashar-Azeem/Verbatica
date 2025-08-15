import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingAnimationOfCustomSize extends StatefulWidget {
  final Widget child;
  const LoadingAnimationOfCustomSize({super.key, required this.child});

  @override
  State<LoadingAnimationOfCustomSize> createState() =>
      _LoadingAnimationOfCustomSizeState();
}

class _LoadingAnimationOfCustomSizeState
    extends State<LoadingAnimationOfCustomSize> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor:
          isDarkMode
              ? Color.fromARGB(255, 34, 45, 52)
              : const Color.fromARGB(255, 128, 157, 175),
      highlightColor:
          isDarkMode
              ? Color.fromARGB(255, 68, 87, 97)
              : const Color.fromARGB(255, 159, 194, 216),
      child: widget.child,
    );
  }
}
