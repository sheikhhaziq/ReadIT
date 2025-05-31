import 'package:isar/isar.dart';
import 'package:readit/models/channel.dart';

part 'feed_item.g.dart';

@collection
class FeedItem {
  Id id = Isar.autoIncrement;

  late String title;
  String? link;
  String? description;
  String? content;
  DateTime? published;
  String? image;
  String? creator;
  String? publisher;
  String? rights;
  String? language;
  String? guid;
  bool isRead = false;
  bool isBookmarked = false;

  final channel = IsarLink<Channel>();
}
