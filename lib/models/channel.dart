import 'package:isar/isar.dart';
import 'package:readit/models/category.dart';
import 'feed.dart';

part 'channel.g.dart';

@collection
class IsarChannel {
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

  final feeds = IsarLinks<IsarFeed>();
  final category = IsarLink<IsarCategory>();
}
