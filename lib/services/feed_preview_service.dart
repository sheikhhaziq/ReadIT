import 'feeds/feed_parser.dart';
import 'feeds/models/channel.dart';

class FeedPreviewService {
  Future<Channel?> previewFeed(String url) async {
    try {
      return await FeedParser.parseFromUrl(url);
    } catch (e) {
      print('Error parsing feed: $e');
      return null;
    }
  }
}
