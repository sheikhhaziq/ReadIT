import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:readit/models/article.dart';
import 'package:readit/models/channel.dart';
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
