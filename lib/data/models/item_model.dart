class ItemModel {
  ItemModel({
    required this.title,
    required this.imageUrl,
    required this.episode,
    required this.year,
    required this.href,
    required this.isFilm,
  });

  String? title;
  String? imageUrl;
  String? episode;
  String? year;
  String? href;
  bool? isFilm;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'episode': episode,
      'year': year,
      'href': href,
      'isFilm': isFilm
    };
  }

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      title: json['title'],
      imageUrl: json['imageUrl'],
      episode: json['episode'],
      year: json['year'],
      href: json['href'],
      isFilm: json['isFilm'],
    );
  }
}
