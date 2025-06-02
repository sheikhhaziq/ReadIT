import 'package:readit/Services/feeds/feed_parser.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'content_viewmodel.g.dart';

@riverpod
class ContentViewmodel extends _$ContentViewmodel {
  @override
  Future<String> build(String url) async {
    return FeedParser.getArticleContentFromUrl(url);
  }
}
