import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:isar/isar.dart';
import '../models/article_with_channel.dart';
import '../models/article.dart';
import 'isar_provider.dart';

part 'article_channel_provider.g.dart';

@riverpod
Future<List<ArticleWithChannel>> articleWithChannelPage(
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
      ),
    );
  }

  return result;
}
