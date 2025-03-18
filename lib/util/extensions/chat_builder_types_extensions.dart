import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'dart:ui';

extension Ex on MessageType {
  bool get isImage => this == MessageType.image;
  bool get isVideo => this == MessageType.video;
  bool get isAudio => this == MessageType.audio;
  bool get isFile => this == MessageType.file;
  bool get isText => this == MessageType.text;
}

extension MessageEx on Message {
  Map<String, List<String>> get reactions => Map<String, List<String>>.fromEntries(
        (this.metadata!['reactions'] as Map<String, dynamic>)
            .entries
            .where((entry) => entry.value.isNotEmpty)
            .map((entry) => MapEntry(entry.key, List<String>.from(entry.value))),
      );

  double aspectRatio() {
    if (type.isImage) {
      return (this as ImageMessage).width! / (this as ImageMessage).height!;
    } else if (type.isVideo) {
      return (this as VideoMessage).width! / (this as ImageMessage).height!;
    } else {
      return 1;
    }
  }

  bool get isDeleted => metadata!['isDeleted'] == true;
}

extension UserEx on User {
  static final List<Color> _lightColors = [
    const Color(0xFFFFA500), // Orange
    const Color(0xFFDA70D6), // Orchid
    const Color(0xFFB22222), // Firebrick
    const Color(0xFF8A2BE2), // Blue Violet
    const Color(0xFFCD5C5C), // Indian Red
    const Color(0xFF9ACD32), // Yellow Green
  ];

  Color get color {
    final index = id.hashCode % _lightColors.length;
    return _lightColors[index];
  }
}
