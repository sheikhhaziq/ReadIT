import 'package:isar/isar.dart';
import 'package:readit/models/article.dart';
import 'package:readit/models/category.dart';

part 'channel.g.dart';

@collection
class IsarChannel {
  Id id = Isar.autoIncrement;

  late String title;
  late String feedUrl;
  String? link;
  String? description;
  String? image;
  String? creator;
  String? publisher;
  String? rights;
  String? language;
  DateTime? lastBuildDate;
  DateTime lastUpdated = DateTime.now();

  final articles = IsarLinks<IsarArticle>();

  final category = IsarLink<IsarCategory>();
}
