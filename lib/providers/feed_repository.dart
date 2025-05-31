import 'package:isar/isar.dart';
import 'package:readit/models/category.dart';
import 'package:readit/models/channel.dart';
import 'package:readit/models/feed_item.dart';
import 'package:readit/services/feeds/feed_parser.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'isar_provider.dart';

part 'feed_repository.g.dart';

@riverpod
class FeedRepository extends _$FeedRepository {
  @override
  FutureOr<void> build() {}

  Future<void> addFeedFromUrl(String url, Category category) async {
    final isar = await ref.read(isarProvider.future);

    final parsedChannel = await FeedParser.parseFromUrl(url);
    if (parsedChannel == null) return;

    final channel = Channel()
      ..title = parsedChannel.title
      ..link = parsedChannel.link
      ..description = parsedChannel.description
      ..image = parsedChannel.image
      ..creator = parsedChannel.creator
      ..publisher = parsedChannel.publisher
      ..rights = parsedChannel.rights
      ..language = parsedChannel.language;

    final feedItems = parsedChannel.feeds.map((f) {
      return FeedItem()
        ..title = f.title
        ..link = f.link
        ..description = f.description
        ..content = f.content
        ..published = f.published
        ..image = f.image
        ..creator = f.creator
        ..publisher = f.publisher
        ..rights = f.rights
        ..language = f.language
        ..guid = f.guid;
    }).toList();

    await isar.writeTxn(() async {
      await isar.feedItems.putAll(feedItems);
      channel.feeds.addAll(feedItems);
      await isar.channels.put(channel);
      await channel.feeds.save();

      category.channels.add(channel);
      await isar.categorys.put(category);
      await category.channels.save();
    });
  }

  Future<List<Channel>> getChannelsByCategory(Category category) async {
    await category.channels.load();
    return category.channels.toList();
  }

  Future<List<Category>> getAllCategories() async {
    final isar = await ref.read(isarProvider.future);
    return await isar.categorys.where().findAll();
  }

  Future<void> createCategory(String name) async {
    final isar = await ref.read(isarProvider.future);
    final category = Category()..name = name;
    await isar.writeTxn(() => isar.categorys.put(category));
  }
}
