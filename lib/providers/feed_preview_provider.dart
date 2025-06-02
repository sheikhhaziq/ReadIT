import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/feeds/models/channel.dart';
import '../services/feed_preview_service.dart';

part 'feed_preview_provider.g.dart';

@riverpod
class FeedPreview extends _$FeedPreview {
  @override
  FutureOr<Channel?> build() => null;

  Future<void> load(String url) async {
    final service = FeedPreviewService();
    state = const AsyncLoading();
    final result = await service.previewFeed(url);
    state = AsyncData(result);
  }

  void clear() => state = const AsyncData(null);
}
