import 'package:isar/isar.dart';
import 'package:readit/models/category.dart';
import 'package:readit/models/feed.dart';
import 'package:readit/providers/isar_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_provider.g.dart';

// final categoryReadCountProvider = Provider((ref, categoryId) async {
//   return;
// });

@riverpod
class CategoryItem extends _$CategoryItem {
  late Isar _isar;
  @override
  Future<List<IsarCategory>> build() async {
    _isar = await ref.read(isarProvider.future);
    final cats = await _isar.isarCategorys.where().findAll();
    for (var cat in cats) {
      await cat.channels.load();
    }
    return cats;
  }

  Future<bool> addCategory(String name) async {
    final cat = await _isar.isarCategorys
        .filter()
        .nameEqualTo(name)
        .findFirst();
    if (cat != null) return false;
    final caterory = IsarCategory()..name = name;
    await _isar.writeTxn(() async {
      await _isar.isarCategorys.put(caterory);
    });
    final newCategories = await _isar.isarCategorys.where().findAll();
    state = AsyncValue.data(newCategories);
    return true;
  }

  Future<void> toggleBookmarkStatus(Isar isar, int itemId) async {
    await isar.writeTxn(() async {
      final item = await isar.isarFeeds.get(itemId);
      if (item != null) {
        item.isBookmarked = !item.isBookmarked;
        await isar.isarFeeds.put(item);
      }
    });
  }
}
