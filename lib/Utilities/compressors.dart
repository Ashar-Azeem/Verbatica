import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:video_compress/video_compress.dart';

Future<File> compressImage(File file) async {
  final compressed = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    "${file.parent.path}/compressed_${file.uri.pathSegments.last}",
    quality: 50,
  );

  if (compressed != null) {
    return File(compressed.path);
  }
  throw Exception("Something went wrong while preparing the image");
}

Future<File> compressVideo(File file) async {
  MediaInfo? compressedInfo = await VideoCompress.compressVideo(
    file.path,
    includeAudio: true,
    quality: VideoQuality.MediumQuality,
    deleteOrigin: false,
  );
  if (compressedInfo == null || compressedInfo.file == null) {
    throw Exception("Something went wrong while preparing the video");
  }

  File finalFile = compressedInfo.file!;
  double sizeMB = finalFile.lengthSync() / (1024 * 1024);
  print("📦 Size after Medium: ${sizeMB.toStringAsFixed(2)} MB");
  return finalFile;
}
