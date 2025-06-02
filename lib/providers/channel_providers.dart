import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:readit/models/article.dart';
import 'package:readit/models/channel.dart';
import 'package:readit/providers/feed_preview_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'isar_provider.dart';

part 'channel_providers.g.dart';

@riverpod
Stream<(IsarChannel, int)> channelWithUnreadCount(
  Ref ref,
  Id channelId,
) async* {
  final isar = await ref.watch(isarInstanceProvider.future);

  // Watch articles for changes related to this channel
  final articleStream = isar.isarArticles
      .filter()
      .channel((q) => q.idEqualTo(channelId))
      .isReadEqualTo(false)
      .watchLazy(fireImmediately: true);

  await for (final _ in articleStream) {
    final channel = await isar.isarChannels.get(channelId);
    if (channel == null) continue;

    final unreadCount = await isar.isarArticles
        .filter()
        .channel((q) => q.idEqualTo(channelId))
        .isReadEqualTo(false)
        .count();

    yield (channel, unreadCount);
  }
}

@riverpod
Future<void> syncChannel(Ref ref, Id channelId, {IsarChannel? channel}) async {
  final isar = await ref.watch(isarInstanceProvider.future);

  channel ??= await isar.isarChannels.where().idEqualTo(channelId).findFirst();

  if (channel == null) {
    return;
  }
  IsarChannel isarChannel = channel;

  try {
    final parsed = await ref
        .read(feedPreviewProvider.notifier)
        .getFeed(channel.feedUrl);
    if (parsed == null) {
      return;
    }
    if (parsed.lastBuildDate != null &&
        parsed.lastBuildDate == channel.lastBuildDate) {
      return;
    }
    final existingGuids = await isar.isarArticles
        .filter()
        .channel((q) => q.idEqualTo(isarChannel.id))
        .guidIsNotNull()
        .findAll()
        .then((list) => list.map((a) => a.guid).toSet());

    final newArticles = parsed.feeds.where((article) {
      return article.guid != null && !existingGuids.contains(article.guid);
    });
    if (newArticles.isEmpty) return;

    await isar.writeTxn(() async {
      final isarArticles = newArticles.map((a) {
        final article = IsarArticle()
          ..title = a.title
          ..link = a.link
          ..description = a.description
          ..content = a.content
          ..published = a.published
          ..image = a.image
          ..creator = a.creator
          ..publisher = a.publisher
          ..rights = a.rights
          ..language = a.language
          ..guid = a.guid
          ..isRead = false
          ..channel.value = isarChannel; // Set reverse link

        return article;
      }).toList();
      for (final article in isarArticles) {
        await isar.isarArticles.put(article);
        await article.channel.save();
      }

      isarChannel.lastUpdated = DateTime.now();
      isarChannel.lastBuildDate = parsed.lastBuildDate;
      await isar.isarChannels.put(isarChannel);
    });
  } catch (e) {
    // Optionally: Log error per channel
  }
}

@riverpod
Future<void> syncAllChannels(Ref ref) async {
  final isar = await ref.watch(isarInstanceProvider.future);
  final channels = await isar.isarChannels.where().findAll();

  for (final channel in channels) {
    await ref.read(syncChannelProvider(channel.id, channel: channel).future);
  }
}
