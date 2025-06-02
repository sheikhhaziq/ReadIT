import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:readit/models/article_with_channel.dart';
import 'package:readit/models/channel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/article.dart';
import 'isar_provider.dart';

part 'article_providers.g.dart';

@riverpod
Future<List<ArticleWithChannel>> articleWithChannelById(
  Ref ref,
  Id channelId,
  int offset,
  int limit,
) async {
  final isar = await ref.watch(isarInstanceProvider.future);

  final articles = await isar.isarArticles
      .filter()
      .channel((q) => q.idEqualTo(channelId))
      .sortByPublishedDesc()
      .offset(offset)
      .limit(limit)
      .findAll();

  final result = <ArticleWithChannel>[];

  for (final article in articles) {
    await article.channel.load();

    result.add(
      ArticleWithChannel(
        article: article,
        channelTitle: article.channel.value?.title,
        channelImage: article.channel.value?.image,
        channelLink: article.channel.value?.link,
        feedUrl: article.channel.value?.feedUrl,
      ),
    );
  }

  return result;
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

@riverpod
Future<List<ArticleWithChannel>> articleWithChannel(
  Ref ref,
  int offset,
  int limit,
) async {
  final isar = await ref.watch(isarInstanceProvider.future);

  final articles = await isar.isarArticles
      .where()
      .sortByPublishedDesc()
      .offset(offset)
      .limit(limit)
      .findAll();

  final result = <ArticleWithChannel>[];

  for (final article in articles) {
    await article.channel.load();

    result.add(
      ArticleWithChannel(
        article: article,
        channelTitle: article.channel.value?.title,
        channelImage: article.channel.value?.image,
        channelLink: article.channel.value?.link,
        feedUrl: article.channel.value?.feedUrl,
      ),
    );
  }

  return result;
}
