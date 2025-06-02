import 'package:isar/isar.dart';
import 'package:readit/models/article_with_channel.dart';
import 'package:readit/providers/article_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  int _offset = 0;
  final int _limit = 20;
  bool _loadingMore = false;

  @override
  FutureOr<List<ArticleWithChannel>> build() async {
    return await _loadInitial();
  }

  Future<List<ArticleWithChannel>> _loadInitial() async {
    final page = await ref.read(
      articleWithChannelProvider(_offset, _limit).future,
    );
    _offset += _limit;
    return page;
  }

  Future<void> loadMore() async {
    // Prevent double loading
    if (state.isLoading || _loadingMore) return;

    _loadingMore = true;

    try {
      final page = await ref.read(
        articleWithChannelProvider(_offset, _limit).future,
      );
      // Merge new page into existing state
      state = AsyncValue.data([...state.value ?? [], ...page]);
      _offset += _limit;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    } finally {
      _loadingMore = false;
    }
  }

  Future<void> refresh() async {
    _offset = 0;
    state = const AsyncValue.loading();

    try {
      final initial = await _loadInitial();
      state = AsyncValue.data(initial);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> markArticleAsRead(Id articleId) async {
    await ref.read(markReadArticleProvider(articleId).future);

    // Update state manually so UI rebuilds
    final current = state.value;
    if (current != null) {
      final updated = current.map((a) {
        if (a.article.id == articleId) {
          a.article.isRead = true;
        }
        return a;
      }).toList();
      state = AsyncValue.data(updated);
    }
  }
}
