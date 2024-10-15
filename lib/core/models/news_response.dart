import 'media_response.dart';

class NewsResponse {
  final String uri;
  final String url;
  final int id;
  final int assetId;
  final String source;
  final String publishedDate;
  final String updated;
  final String section;
  final String subsection;
  final String nytdsection;
  final String adxKeywords;
  final String byline;
  final String type;
  final String title;
  final String abstract;
  final List<String> desFacet;
  final List<String> orgFacet;
  final List<String> perFacet;
  final List<String> geoFacet;
  final List<MediaResponse> media;
  final int etaId;

  NewsResponse({
    required this.uri,
    required this.url,
    required this.id,
    required this.assetId,
    required this.source,
    required this.publishedDate,
    required this.updated,
    required this.section,
    required this.subsection,
    required this.nytdsection,
    required this.adxKeywords,
    required this.byline,
    required this.type,
    required this.title,
    required this.abstract,
    required this.desFacet,
    required this.orgFacet,
    required this.perFacet,
    required this.geoFacet,
    required this.media,
    required this.etaId,
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    return NewsResponse(
      uri: json['uri'] as String,
      url: json['url'] as String,
      id: json['id'] as int,
      assetId: json['asset_id'] as int,
      source: json['source'] as String,
      publishedDate: json['published_date'] as String,
      updated: json['updated'] as String,
      section: json['section'] as String,
      subsection: json['subsection'] as String,
      nytdsection: json['nytdsection'] as String,
      adxKeywords: json['adx_keywords'] as String,
      byline: json['byline'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      abstract: json['abstract'] as String,
      desFacet: (json['des_facet'] as List<dynamic>).cast<String>(),
      orgFacet: (json['org_facet'] as List<dynamic>).cast<String>(),
      perFacet: (json['per_facet'] as List<dynamic>).cast<String>(),
      geoFacet: (json['geo_facet'] as List<dynamic>).cast<String>(),
      media: (json['media'] as List<dynamic>)
          .map((e) => MediaResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      etaId: json['eta_id'] as int,
    );
  }
}