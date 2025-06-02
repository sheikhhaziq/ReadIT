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
Future<void> syncChannel(Ref ref, Id channelId) async {
  final isar = await ref.watch(isarInstanceProvider.future);
  final channel = await isar.isarChannels
      .where()
      .idEqualTo(channelId)
      .findFirst();
  if (channel == null) {
    return;
  }

  if (channel.link == null) return;

  try {
    await ref.read(feedPreviewProvider.notifier).load(channel.link!);
    final parsed = await ref.read(feedPreviewProvider.future);
    if (parsed == null) {
      return;
    }
    final existingGuids = await isar.isarArticles
        .filter()
        .channel((q) => q.idEqualTo(channel.id))
        .guidIsNotNull()
        .findAll()
        .then((list) => list.map((a) => a.guid).toSet());

    final newArticles = parsed.feeds.where((article) {
      return article.guid != null && !existingGuids.contains(article.guid);
    });

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
          ..channel.value = channel; // Set reverse link

        return article;
      }).toList();
      for (final article in isarArticles) {
        await isar.isarArticles.put(article);
        await article.channel.save();
      }

      channel.lastUpdated = DateTime.now();
      await isar.isarChannels.put(channel);
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
    await ref.read(syncChannelProvider(channel.id).future);
  }
}

// @riverpod
// Future<IsarChannel?> channelWithArticles(Ref ref, Id channelId) async {
//   final isar = await ref.watch(isarInstanceProvider.future);

//   final channel = await isar.isarChannels
//       .where()
//       .idEqualTo(channelId)
//       .findFirst();
//   await channel?.articles.load();

//   return channel;
// }

// @riverpod
// Future<List<IsarChannel>> channelsByCategory(Ref ref, Id categoryId) async {
//   final isar = await ref.watch(isarInstanceProvider.future);
//   final category = await isar.isarCategorys.get(categoryId);
//   await category?.channels.load();
//   return category?.channels.toList() ?? [];
// }

// @riverpod
// Future<List<ChannelWithUnreadCount>> channelsForCategory(
//   Ref ref,
//   int categoryId,
// ) async {
//   final isar = await ref.watch(isarInstanceProvider.future);
//   final category = await isar.isarCategorys.get(categoryId);

//   if (category == null) return [];

//   await category.channels.load();

//   final result = <ChannelWithUnreadCount>[];
//   for (final channel in category.channels) {
//     await channel.articles.load();
//     final unread = channel.articles.where((a) => !a.isRead).length;
//     result.add(ChannelWithUnreadCount(channel, unread));
//   }

//   return result;
// }
