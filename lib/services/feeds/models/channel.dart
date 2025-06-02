import 'package:readit/services/feeds/models/feed.dart';

class Channel {
  final String title;
  final String feedUrl;
  final String link;
  final String description;
  final String? image;
  final String? creator;
  final String? publisher;
  final String? rights;
  final String? language;
  final DateTime? lastBuildDate;

  List<FeedItem> feeds;

  Channel({
    required this.title,
    required this.feedUrl,
    required this.link,
    required this.description,
    this.feeds = const [],
    this.image,
    this.creator,
    this.publisher,
    this.rights,
    this.language,
    this.lastBuildDate,
  });

  @override
  String toString() {
    final feedString = feeds.map((feed) => feed.toString()).toList().join('\n');
    return 'Title: $title\nLink: $link\ndescription: $description\nimage: $image\nfeeds:  $feedString';
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'feedUrl': feedUrl,
      'link': link,
      'description': description,
      'image': image,
      'feeds': feeds.map((feed) => feed.toMap()).toList(),
      'creator': creator,
      'publisher': publisher,
      'language': language,
      'rights': rights,
      'lastBuildDate': lastBuildDate,
    };
  }
}
