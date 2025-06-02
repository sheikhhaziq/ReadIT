import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:readit/models/channel.dart';
import 'package:readit/providers/category_providers.dart';
import 'package:readit/providers/channel_providers.dart';
import 'package:readit/providers/isar_provider.dart';
import 'package:readit/widgets/dynamic_network_image.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(allCategoriesWithChannelIdsProvider);
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              FilledButton(
                onPressed: () async {
                  final isar = await ref.read(isarInstanceProvider.future);
                  final cats = await isar.isarChannels
                      .where()
                      .idEqualTo(1)
                      .findFirst();
                  await cats?.articles.load();
                  print(cats?.articles);
                },
                child: Text("try"),
              ),
              ...?categoriesAsync.whenOrNull(
                data: (data) => data
                    .map(
                      (ct) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: ExpansionTile(
                          title: Row(children: [Text(ct.$1.name)]),

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
                          children: ct.$2
                              .map(
                                (channelId) =>
                                    DrawerChannelTile(channelId: channelId),
                              )
                              .toList(),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class DrawerChannelList extends ConsumerWidget {
//   const DrawerChannelList({super.key, required this.categoryId});
//   final Id categoryId;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final channelForCategory = ref.watch(
//       channelsForCategoryProvider(categoryId),
//     );
//     return channelForCategory.when(
//       data: (channels) {
//         return channels.map((ch) => ListTile()).toList();
//       },
//       error: (e, s) => SizedBox.shrink(),
//       loading: () => SizedBox.shrink(),
//     );
//   }
// }

// category.channels.map((channel) {
//                             return Text("");
//                           }).toList(),

class DrawerChannelTile extends ConsumerWidget {
  const DrawerChannelTile({super.key, required this.channelId});
  final Id channelId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelWithUnreadCount = ref.watch(
      channelWithUnreadCountProvider(channelId),
    );
    return channelWithUnreadCount.when(
      data: (data) {
        final channel = data.$1;
        return ListTile(
          trailing: Badge(
            backgroundColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.onPrimary,
            label: Text(data.$2.toString()),
          ),
          leading: channel.image != null
              ? DynamicNetworkImage(channel.image!, height: 30, width: 30)
              : SizedBox(
                  width: 30,
                  height: 30,
                  child: CircleAvatar(
                    radius: 30,
                    child: Text(
                      channel.title.split(" ").map((e) => e[0]).join(),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ),
          title: Text(
            channel.title,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        );
      },
      error: (e, s) => SizedBox.shrink(),
      loading: () => SizedBox.shrink(),
    );
  }
}
