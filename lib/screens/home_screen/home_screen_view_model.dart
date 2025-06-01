import 'package:isar/isar.dart';
import 'package:readit/models/feed.dart';
import 'package:readit/providers/isar_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_screen_view_model.g.dart';

@riverpod
class HomeScreenViewModel extends _$HomeScreenViewModel {
  late Isar _isar;
  int _page = 0;
  final int _limit = 10;
  bool _completed = false;
  @override
  Future<List<IsarFeed>> build() async {
    _isar = await ref.read(isarProvider.future);
    return fetchItems();
  }

  Future<List<IsarFeed>> fetchItems() async {
    final items = await _isar.isarFeeds
        .where()
        .sortByPublishedDesc()
        .offset(_page * _limit)
        .limit(_limit)
        .findAll();
    for (var item in items) {
      await item.channel.load();
    }
    _completed = items.length < _limit;
    return items;
  }

  Future<bool> fetchMore() async {
    _page++;
    final moreItems = await fetchItems();
    state = AsyncValue.data([...state.value ?? [], ...moreItems]);
    _completed = moreItems.length < _limit;
    return _completed;
  }

  Future<void> refreshItems() async {
    _page = 0;
    state = const AsyncLoading();
    final newItems = await fetchItems();
    state = AsyncValue.data(newItems);
  }
}
