import '../models/category.dart';
import '../models/channel.dart';

class ChannelWithUnreadCount {
  final IsarChannel channel;
  final int unreadCount;

  ChannelWithUnreadCount(this.channel, this.unreadCount);
}

class CategoryWithChannels {
  final IsarCategory category;
  final List<ChannelWithUnreadCount> channels;

  CategoryWithChannels(this.category, this.channels);
}
