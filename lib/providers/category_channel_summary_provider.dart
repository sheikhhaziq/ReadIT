import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/category.dart';
import '../models/article.dart';
import '../models/summary_models.dart';
import 'isar_provider.dart';

part 'category_channel_summary_provider.g.dart';

@riverpod
Stream<List<CategoryWithChannels>> categoryChannelSummary(Ref ref) async* {
  final isar = await ref.watch(isarInstanceProvider.future);

  // Watch articles (or channels if you prefer) — your choice
  final watchStream = isar.isarArticles.watchLazy();

  await for (final _ in watchStream) {
    final categories = await isar.isarCategorys.where().findAll();
    final result = <CategoryWithChannels>[];

    for (final category in categories) {
      await category.channels.load();

      final channels = <ChannelWithUnreadCount>[];

      for (final channel in category.channels) {
        await channel.articles.load();
        final unreadCount = channel.articles.where((a) => !a.isRead).length;
        channels.add(ChannelWithUnreadCount(channel, unreadCount));
      }

      result.add(
        CategoryWithChannels(category, channels),
      ); // even if channels is empty
    }

    yield result;
  }
}
