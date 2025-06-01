import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readit/providers/category_provider.dart';
import 'package:readit/screens/home_screen/home_screen_view_model.dart';
import 'package:readit/widgets/add_channel.dart';
import 'package:readit/widgets/dynamic_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBody: true,
      drawer: Drawer(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              ...?ref
                  .watch(categoryItemProvider)
                  .whenOrNull(
                    data: (data) => data
                        .map(
                          (category) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: ExpansionTile(
                              title: Text(category.name),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(25),
                              ),
                              collapsedShape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(25),
                              ),
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              collapsedBackgroundColor: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              children: category.channels.map((category) {
                                return ListTile(
                                  leading: category.image == null
                                      ? CircleAvatar(radius: 20)
                                      : DynamicNetworkImage(
                                          category.image!,
                                          width: 20,
                                          height: 20,
                                        ),
                                  title: Text(
                                    category.title,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelLarge,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        )
                        .toList(),
                  ),
            ],
          ),
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              expandedHeight: 100,
              flexibleSpace: FlexibleSpaceBar(title: Text("Home")),
            ),
          ];
        },
        body: ref
            .watch(homeScreenViewModelProvider)
            .when(
              data: (articles) {
                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  itemCount: articles.length,
                  separatorBuilder: (context, index) => SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final article = articles[index];
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
                                Text(
                                  article.publisher ?? article.creator ?? '',
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                ),
                                if (article.published != null)
                                  Text(
                                    timeago.format(article.published!),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelSmall,
                                  ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        article.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(height: 1.1),
                                      ),
                                      SizedBox(height: 4),
                                      if (article.description != null)
                                        Text(
                                          article.description!,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                height: 1.1,
                                                color: Theme.of(
                                                  context,
                                                ).hintColor,
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
                  },
                );
              },
              error: (e, s) => Center(child: Text(e.toString())),
              loading: () => Center(child: CircularProgressIndicator()),
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (context) => AddChannel());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
