import 'package:readit/services/feeds/feed_parser.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/feeds/models/channel.dart';

part 'feed_preview_provider.g.dart';

@riverpod
class FeedPreview extends _$FeedPreview {
  @override
  FutureOr<Channel?> build() => null;

  Future<void> load(String url) async {
    state = const AsyncLoading();
    final result = await FeedParser.parseFromUrl(url);
    state = AsyncData(result);
  }

  Future<Channel?> getFeed(String url) async {
    final result = await FeedParser.parseFromUrl(url);
    return result;
  }

  void clear() => state = const AsyncData(null);
}
