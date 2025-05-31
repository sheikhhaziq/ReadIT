import 'package:isar/isar.dart';
import 'package:readit/models/category.dart';
import 'feed_item.dart';

part 'channel.g.dart';

@collection
class Channel {
  Id id = Isar.autoIncrement;

  late String title;
  String? link;
  String? description;
  String? image;
  String? creator;
  String? publisher;
  String? rights;
  String? language;
  DateTime lastUpdated = DateTime.now();

  final feeds = IsarLinks<FeedItem>();
  final category = IsarLink<Category>();
}
