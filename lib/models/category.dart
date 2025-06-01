import 'package:isar/isar.dart';

import 'channel.dart';

part 'category.g.dart';

@collection
class IsarCategory {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String name;

  @Backlink(to: 'category')
  final channels = IsarLinks<IsarChannel>();
}

class CategoryWithUnread {
  final String name;
  final int unreadCount;
  final List<ChannelWithUnread> channels;

  CategoryWithUnread(this.name, this.unreadCount, this.channels);
}
