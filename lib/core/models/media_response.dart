import 'media_metadata_response.dart';

class MediaResponse {
  final String type;
  final String subtype;
  final String caption;
  final String copyright;
  final int approvedForSyndication;
  final List<MediaMetadata> mediaMetadata;

  MediaResponse({
    required this.type,
    required this.subtype,
    required this.caption,
    required this.copyright,
    required this.approvedForSyndication,
    required this.mediaMetadata,
  });

  factory MediaResponse.fromJson(Map<String, dynamic> json) {
    return MediaResponse(
      type: json['type'] as String,
      subtype: json['subtype'] as String,
      caption: json['caption'] as String,
      copyright: json['copyright'] as String,
      approvedForSyndication: json['approved_for_syndication'] as int,
      mediaMetadata: (json['media-metadata'] as List<dynamic>)
          .map((e) => MediaMetadata.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}