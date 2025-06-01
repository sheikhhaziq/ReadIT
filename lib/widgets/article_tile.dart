import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:readit/models/feed.dart';
import 'package:readit/widgets/dynamic_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

class ArticleTile extends StatelessWidget {
  const ArticleTile({super.key, required this.article});

  final IsarFeed article;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () async {
        if (article.link != null) {
          await launchUrl(Uri.parse(article.link!));
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child:
                          (article.channel.value?.image != null ||
                              article.channel.value?.title != null)
                          ? CircleAvatar(
                              radius: 30,
                              child: article.channel.value?.image != null
                                  ? ClipRRect(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(15),
                                      child: DynamicNetworkImage(
                                        article.channel.value!.image!,
                                        height: 30,
                                        width: 30,
                                      ),
                                    )
                                  : Text(
                                      article.channel.value!.title
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
                    if (article.channel.value?.title != null)
                      SizedBox(width: 8),
                    if (article.channel.value?.title != null)
                      Text(
                        article.channel.value!.title,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
