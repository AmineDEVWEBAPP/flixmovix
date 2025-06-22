class ItemDetailsModel {
  ItemDetailsModel({
    required this.title,
    required this.imageUrl,
    required this.year,
    required this.arabicName,
    required this.quality,
    required this.type,
    required this.alsoKnownAs,
    required this.classification,
    required this.duration,
    required this.storyMovie,
    required this.iframe,
    required this.seasions,
    required this.episodes,
    required this.isFilm,
    required this.similarOffers,
  });
  String? title;
  String? imageUrl;
  String? year;
  String? arabicName;
  String? quality;
  String? type;
  String? duration;
  String? alsoKnownAs;
  String? classification;
  String? storyMovie;
  String? iframe;
  Set? seasions;
  Set? episodes;
  bool? isFilm;
  Set? similarOffers;

  factory ItemDetailsModel.fromJson(Map<String, dynamic> json) {
    return ItemDetailsModel(
      title: json['details']['title'],
      imageUrl: json['details']['imageUrl'],
      year: json['details']['year'],
      arabicName: json['details']['arabicName'],
      quality: json['details']['quality'],
      type: json['details']['type'],
      alsoKnownAs: json['details']['alsoKnownAs'],
      classification: json['details']['classification'],
      duration: json['details']['duration'],
      storyMovie: json['details']['storyMovie'],
      iframe: json['details']['iframe'],
      episodes: json['details']['episodes'],
      isFilm: json['details']['isFilm'],
      similarOffers: json['similarOffer'],
      seasions: json['seasions'],
    );
  }
}
