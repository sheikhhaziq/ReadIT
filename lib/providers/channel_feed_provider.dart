import 'package:isar/isar.dart';
import 'package:readit/models/channel.dart';
import 'package:readit/models/feed.dart';
import 'package:readit/providers/isar_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'channel_feed_provider.g.dart';

@riverpod
class ChannelFeedItems extends _$ChannelFeedItems {
  @override
  Future<List<IsarFeed>> build(int channelId) async {
    final isar = await ref.read(isarProvider.future);
    return await isar.isarFeeds
        .filter()
        .channel((q) => q.idEqualTo(channelId))
        .sortByPublishedDesc()
        .findAll();
  }

  Future<void> toggleReadStatus(int itemId) async {
    final isar = await ref.read(isarProvider.future);
    await isar.writeTxn(() async {
      final item = await isar.isarFeeds.get(itemId);
      if (item != null) {
        item.isRead = !item.isRead;
        await isar.isarFeeds.put(item);
      }
    });
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
