import 'package:isar/isar.dart';
import 'package:readit/models/channel.dart';

part 'article.g.dart';

@collection
class IsarArticle {
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

  final channel = IsarLink<IsarChannel>();
}
