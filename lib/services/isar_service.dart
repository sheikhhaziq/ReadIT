import 'package:isar/isar.dart';
import 'package:readit/models/article.dart';
import '../models/category.dart';
import '../models/channel.dart';
import 'package:path_provider/path_provider.dart';

Future<Isar> getIsarInstance() async {
  final dir = await getApplicationDocumentsDirectory();
  return await Isar.open(
    [IsarCategorySchema, IsarChannelSchema, IsarArticleSchema],
    directory: dir.path,
    inspector: true,
  );
}
