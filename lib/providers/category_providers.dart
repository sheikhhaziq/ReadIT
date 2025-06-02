import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:readit/models/channel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/category.dart';
import 'isar_provider.dart';

part 'category_providers.g.dart';

@riverpod
Stream<List<(IsarCategory, List<Id>)>> allCategoriesWithChannelIds(
  Ref ref,
) async* {
  final isar = await ref.watch(isarInstanceProvider.future);
  yield* isar.isarCategorys.where().watch(fireImmediately: true).asyncMap((
    categories,
  ) async {
    return Future.wait(
      categories.map((category) async {
        final ids = await isar.isarChannels
            .filter()
            .category((q) => q.idEqualTo(category.id))
            .idProperty()
            .findAll(); // only fetch channel IDs
        return (category, ids);
      }),
    );
  });
}

@riverpod
Stream<List<IsarCategory>> allCategories(Ref ref) async* {
  final isar = await ref.watch(isarInstanceProvider.future);
  yield* isar.isarCategorys.where().watch(fireImmediately: true);
}

@riverpod
class CategoryController extends _$CategoryController {
  @override
  FutureOr<void> build() {}

  Future<bool> addCategory(String name) async {
    final isar = await ref.read(isarInstanceProvider.future);
    final categoryExists = (await isar.isarCategorys.getByName(name)) != null;
    if (categoryExists) return false;
    final category = IsarCategory()..name = name;
    await isar.writeTxn(() => isar.isarCategorys.put(category));
    ref.invalidate(allCategoriesProvider);
    return true;
  }
}
