import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/category.dart';
import '../models/channel.dart';
import '../models/article.dart';
import '../services/feeds/models/channel.dart';
import './isar_provider.dart';

part 'feed_saver_provider.g.dart';

@riverpod
class FeedSaver extends _$FeedSaver {
  @override
  FutureOr<void> build() {}

  Future<void> save(Channel channel, IsarCategory category) async {
    final isar = await ref.read(isarInstanceProvider.future);

    await isar.writeTxn(() async {
      // Create the channel
      final isarChannel = IsarChannel()
        ..title = channel.title
        ..link = channel.link
        ..description = channel.description
        ..image = channel.image
        ..creator = channel.creator
        ..publisher = channel.publisher
        ..rights = channel.rights
        ..language = channel.language
        ..category.value = category;

      // Save the channel first so it gets an ID
      await isar.isarChannels.put(isarChannel);

      // Create and link articles to the channel
      final isarArticles = channel.feeds.map((a) {
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

      // Save the articles
      await isar.isarArticles.putAll(isarArticles);

      // Save reverse links for each article
      for (final article in isarArticles) {
        await article.channel.save();
      }

      // Save forward link (channel.articles)
      isarChannel.articles.addAll(isarArticles);
      await isarChannel.articles.save();

      // Save category link (already set)
      await isarChannel.category.save();
    });
  }
}
