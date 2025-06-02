import 'article.dart';

class ArticleWithChannel {
  final IsarArticle article;
  final String? channelTitle;
  final String? channelImage;
  final String? channelLink;
  final String? feedUrl;

  ArticleWithChannel({
    required this.article,
    required this.channelTitle,
    required this.channelImage,
    required this.channelLink,
    required this.feedUrl,
  });
}
