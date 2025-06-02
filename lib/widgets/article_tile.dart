import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readit/models/article.dart';
import 'package:readit/models/article_with_channel.dart';
import 'package:readit/views/content_screen.dart';
import 'package:readit/widgets/dynamic_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;

class ArticleTile extends ConsumerWidget {
  const ArticleTile({
    super.key,
    required this.articleWithChannel,
    required this.onTap,
  });

  final ArticleWithChannel articleWithChannel;

  final void Function(IsarArticle article) onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final article = articleWithChannel.article;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () async {
        onTap(article);
        if (article.link != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ContentScreen(article: article)),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 30,
                        height: 30,
                        child:
                            (articleWithChannel.channelImage != null ||
                                articleWithChannel.channelTitle != null)
                            ? CircleAvatar(
                                radius: 30,
                                child: articleWithChannel.channelImage != null
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(15),
                                        child: DynamicNetworkImage(
                                          articleWithChannel.channelImage!,
                                          height: 30,
                                          width: 30,
                                        ),
                                      )
                                    : Text(
                                        articleWithChannel.channelTitle!
                                            .split(" ")
                                            .map((e) => e[0])
                                            .join(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              color: article.isRead
                                                  ? Theme.of(context).hintColor
                                                  : null,
                                            ),
                                      ),
                              )
                            : null,
                      ),
                      if (articleWithChannel.channelTitle != null)
                        SizedBox(width: 8),
                      if (articleWithChannel.channelTitle != null)
                        Text(
                          articleWithChannel.channelTitle!,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: article.isRead
                                    ? Theme.of(context).hintColor
                                    : Theme.of(context).colorScheme.primary,
                              ),
                        ),
                    ],
                  ),

                  if (article.published != null)
                    Text(
                      timeago.format(article.published!),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: article.isRead
                            ? Theme.of(context).hintColor
                            : null,
                      ),
                    ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (article.image != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: article.image!,
                              width: double.infinity,
                              // height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      Text(
                        article.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          height: 1.1,
                          color: article.isRead
                              ? Theme.of(context).hintColor
                              : null,
                        ),
                      ),
                      SizedBox(height: 4),
                      if (article.description != null)
                        Text(
                          article.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                height: 1.1,
                                color: article.isRead
                                    ? Theme.of(context).hintColor
                                    : null,
                              ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
