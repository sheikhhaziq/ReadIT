import 'package:isar/isar.dart';
import 'package:readit/models/feed_item.dart';
import 'package:readit/providers/isar_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_screen_view_model.g.dart';

@riverpod
class HomeScreenViewModel extends _$HomeScreenViewModel {
  late Isar _isar;
  int page = 0;
  int limit = 10;
  @override
  Future<List<FeedItem>> build() async {
    _isar = await ref.read(isarProvider.future);
    return fetchItems();
    // return AsyncValue.data(items);
  }

  Future<List<FeedItem>> fetchItems() async {
    final items = await _isar.feedItems
        .where()
        .sortByPublishedDesc()
        .offset(page * limit)
        .limit(limit)
        .findAll();

    return items;
  }

  Future<void> fetchMore() async {
    page++;
    final moreItems = await fetchItems();
    state = AsyncValue.data([...state.value ?? [], ...moreItems]);
  }

  Future<void> refreshItems() async {
    page = 0;
    state = const AsyncLoading();
    final newItems = await fetchItems();
    state = AsyncValue.data(newItems);
  }
}
