import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readit/models/article.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class ArticleTile extends ConsumerWidget {
  const ArticleTile({super.key, required this.article, required this.onTap});

  final IsarArticle article;

  final void Function(IsarArticle article) onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () async {
        onTap(article);
        if (article.link != null) {
          await launchUrl(Uri.parse(article.link!));
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          style: Theme.of(context).textTheme.bodyMedium
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
                if (article.image != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: article.image!,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
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
