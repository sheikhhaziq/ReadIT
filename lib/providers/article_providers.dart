import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:readit/models/channel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/article.dart';
import 'isar_provider.dart';

part 'article_providers.g.dart';

@riverpod
Future<List<IsarArticle>> articlesByChannel(
  Ref ref,
  Id channelId,
  int offset,
  int limit,
) async {
  final isar = await ref.watch(isarInstanceProvider.future);

  return isar.isarArticles
      .filter()
      .channel((q) => q.idEqualTo(channelId))
      .sortByPublishedDesc()
      .offset(offset)
      .limit(limit)
      .findAll();
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
