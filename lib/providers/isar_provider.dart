import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:readit/models/category.dart';
import 'package:readit/models/channel.dart';
import 'package:readit/models/feed.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'isar_provider.g.dart';

@Riverpod(keepAlive: true)
Future<Isar> isar(Ref ref) async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([
    IsarChannelSchema,
    IsarFeedSchema,
    IsarCategorySchema,
  ], directory: dir.path);
  // await isar.writeTxn(() async {
  //   await isar.isarCategorys.clear();
  //   await isar.isarChannels.clear();
  //   await isar.isarFeeds.clear();
  // });
  final existing = await isar.isarCategorys
      .filter()
      .nameEqualTo('Default')
      .findFirst();
  if (existing == null) {
    await isar.writeTxn(() async {
      await isar.isarCategorys.put(IsarCategory()..name = 'Default');
    });
  }
  return isar;
}
