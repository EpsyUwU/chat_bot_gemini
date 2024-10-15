class MediaMetadata {
  final String url;
  final String format;
  final int height;
  final int width;

  MediaMetadata({
    required this.url,
    required this.format,
    required this.height,
    required this.width,
  });

  factory MediaMetadata.fromJson(Map<String, dynamic> json) {
    return MediaMetadata(
      url: json['url'] as String,
      format: json['format'] as String,
      height: json['height'] as int,
      width: json['width'] as int,
    );
  }
}