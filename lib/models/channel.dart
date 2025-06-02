import 'package:isar/isar.dart';
import 'package:readit/models/article.dart';
import 'package:readit/models/category.dart';

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

  final articles = IsarLinks<IsarArticle>();

  final category = IsarLink<IsarCategory>();
}
