class FeedItem {
  final String title;
  final String link;
  final String description;
  final String? content;
  final DateTime? published;
  final String? image;
  final String? guid;
  final String? creator;
  final String? publisher;
  final String? rights;
  final String? language;

  FeedItem({
    required this.title,
    required this.link,
    required this.description,
    this.published,
    this.image,
    this.guid,
    this.content,
    this.creator,
    this.publisher,
    this.rights,
    this.language,
  });

  @override
  String toString() {
    return 'Title: $title\nLink: $link\ndescription: $description\ncontent: $content\nPublished: $published\nimage: $image\nguid: $guid';
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'link': link,
      'description': description,
      'content': content,
      'published': published.toString(),
      'image': image,
      'guid': guid,
      'creator': creator,
      'publisher': publisher,
      'language': language,
      'rights': rights,
    };
  }
}
