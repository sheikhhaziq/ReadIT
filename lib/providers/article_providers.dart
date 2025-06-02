import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:readit/models/channel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/article.dart';
import 'isar_provider.dart';

part 'article_providers.g.dart';

@riverpod
Future<List<IsarArticle>> articlesByChannel(Ref ref, Id channelId) async {
  final isar = await ref.watch(isarInstanceProvider.future);
  final channel = await isar.isarChannels.get(channelId);
  await channel?.articles.load();
  return channel?.articles.toList() ?? [];
}

@riverpod
Future<void> markReadArticle(Ref ref, Id articleId) async {
  final isar = await ref.watch(isarInstanceProvider.future);

  await isar.writeTxn(() async {
    final article = await isar.isarArticles.get(articleId);
    if (article != null) {
      article.isRead = true;
      await isar.isarArticles.put(article); // Save updated article
    }
  });
}
