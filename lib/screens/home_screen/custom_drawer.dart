import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readit/providers/category_provider.dart';
import 'package:readit/widgets/dynamic_network_image.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
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
                              title: Row(children: [Text(category.name)]),
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
                              children: category.channels.map((channel) {
                                return ListTile(
                                  leading: channel.image != null
                                      ? DynamicNetworkImage(
                                          channel.image!,
                                          height: 30,
                                          width: 30,
                                        )
                                      : SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: CircleAvatar(
                                            radius: 30,
                                            child: Text(
                                              channel.title
                                                  .split(" ")
                                                  .map((e) => e[0])
                                                  .join(),
                                              style: Theme.of(
                                                context,
                                              ).textTheme.labelSmall,
                                            ),
                                          ),
                                        ),
                                  title: Text(
                                    channel.title,
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
    );
  }
}
