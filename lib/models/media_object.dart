import 'package:video_player/video_player.dart';
import 'package:flutter/src/painting/image_decoder.dart';
import 'dart:ui' as ui;
import 'dart:io';

enum FileType { image, video, audio, file }

class FileTypeHelper {
  FileTypeHelper._();

  static FileType getFileTypeFromString(String fileType) {
    switch (fileType) {
      case 'image':
        return FileType.image;
      case 'video':
        return FileType.video;
      case 'audio':
        return FileType.audio;
      case 'file':
        return FileType.file;
      default:
        throw Exception('FileTypeHelper: getFileTypeFromString: Unsupported file type');
    }
  }
}

class MediaObject {
  final String downloadUrl;
  final int width;
  final int height;
  final int duration;
  final FileType type;

  MediaObject({
    required this.downloadUrl,
    required this.width,
    required this.height,
    required this.type,
    this.duration = 0,
  });

  bool get isImage => type == FileType.image;
  bool get isVideo => type == FileType.video;

  static Future<MediaObject?> fromFile({
    required String filePath,
    required FileType fileType,
    required String downloadUrl,
    int audioDuration = 0,
  }) async {
    if (fileType == FileType.image) {
      final fileBytes = await File(filePath).readAsBytes();
      final ui.Image image = await decodeImageFromList(fileBytes);

      return MediaObject(
        downloadUrl: downloadUrl,
        width: image.width,
        height: image.height,
        type: fileType,
        duration: audioDuration,
      );
    }

    if (fileType == FileType.video) {
      final videoPlayerController = VideoPlayerController.file(File(filePath));
      await videoPlayerController.initialize();

      final videoSize = videoPlayerController.value.size;

      return MediaObject(
        downloadUrl: downloadUrl,
        width: videoSize.width.toInt(),
        height: videoSize.height.toInt(),
        duration: audioDuration,
        type: fileType,
      );
    }

    if (fileType == FileType.audio || fileType == FileType.file) {
      return MediaObject(
        downloadUrl: downloadUrl,
        width: 0,
        height: 0,
        type: fileType,
        duration: audioDuration,
      );
    }

    return null;
  }

  factory MediaObject.fromJson(Map<String, dynamic> json) {
    return MediaObject(
      downloadUrl: json['downloadUrl'],
      width: json['width'],
      height: json['height'],
      duration: json['duration'] ?? 0,
      type: FileTypeHelper.getFileTypeFromString(json['type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'downloadUrl': downloadUrl,
      'width': width,
      'height': height,
      'duration': duration,
      'type': type.name,
    };
  }

  double get aspectRatio => width / height;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MediaObject &&
        other.downloadUrl == downloadUrl &&
        other.width == width &&
        other.height == height &&
        other.duration == duration &&
        other.type == type;
  }

  @override
  int get hashCode {
    return downloadUrl.hashCode ^ width.hashCode ^ height.hashCode ^ duration.hashCode ^ type.hashCode;
  }
}
