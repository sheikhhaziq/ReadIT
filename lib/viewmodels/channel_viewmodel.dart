import 'package:isar/isar.dart';
import 'package:readit/models/article.dart';
import 'package:readit/providers/article_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'channel_viewmodel.g.dart';

@riverpod
class ChannelViewmodel extends _$ChannelViewmodel {
  late Id _channelId;
  int _offset = 0;
  final int _limit = 20;
  bool _loadingMore = false;
  bool _completed = false;

  @override
  Future<List<IsarArticle>> build(Id channelId) async {
    _channelId = channelId;

    return _loadInitial();
  }

  Future<List<IsarArticle>> _loadInitial() async {
    final articles = await ref.read(
      articlesByChannelProvider(_channelId, _offset, _limit).future,
    );
    _offset += _limit;
    _completed = articles.length < _limit;
    return articles;
  }

  Future<void> loadMore() async {
    // Prevent double loading
    if (state.isLoading || _loadingMore || _completed) return;

    _loadingMore = true;

    try {
      final articles = await ref.refresh(
        articlesByChannelProvider(_channelId, _offset, _limit).future,
      );
      // Merge new articles into existing state
      state = AsyncValue.data([...state.value ?? [], ...articles]);
      _offset += _limit;
      _completed = articles.length < _limit;
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

    final current = state.value; // ChannelWithArticles
    if (current != null) {
      final updatedArticles = current.map<IsarArticle>((a) {
        if (a.id == articleId) {
          a.isRead = true;
        }
        return a;
      }).toList();

      state = AsyncValue.data(updatedArticles);
    }
  }
}
