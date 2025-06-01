import 'package:isar/isar.dart';
import 'package:readit/models/category.dart';
import 'package:readit/models/channel.dart';
import 'package:readit/models/feed.dart';
import 'package:readit/services/feeds/feed_parser.dart';
import 'package:readit/services/feeds/models/channel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'isar_provider.dart';

part 'feed_repository.g.dart';

@riverpod
class FeedRepository extends _$FeedRepository {
  @override
  FutureOr<void> build() {}

  Future<Channel?> getChannelFromUrl(String url) async {
    final parsedChannel = await FeedParser.parseFromUrl(url);
    return parsedChannel;
  }

  Future<void> addFeed(Channel channel, IsarCategory category) async {
    final isar = await ref.read(isarProvider.future);
    final isarchannel = IsarChannel()
      ..title = channel.title
      ..link = channel.link
      ..description = channel.description
      ..image = channel.image
      ..creator = channel.creator
      ..publisher = channel.publisher
      ..rights = channel.rights
      ..language = channel.language;

    final feedItems = channel.feeds.map((f) {
      return IsarFeed()
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
      await isar.isarFeeds.putAll(feedItems);
      isarchannel.feeds.addAll(feedItems);
      await isar.isarChannels.put(isarchannel);
      await isarchannel.feeds.save();

      category.channels.add(isarchannel);
      await isar.isarCategorys.put(category);
      await category.channels.save();
    });
  }

  Future<List<IsarChannel>> getChannelsByCategory(IsarCategory category) async {
    await category.channels.load();
    return category.channels.toList();
  }

  Future<List<IsarCategory>> getAllCategories() async {
    final isar = await ref.read(isarProvider.future);
    return await isar.isarCategorys.where().findAll();
  }

  Future<void> createCategory(String name) async {
    final isar = await ref.read(isarProvider.future);
    final category = IsarCategory()..name = name;
    await isar.writeTxn(() => isar.isarCategorys.put(category));
  }
}
