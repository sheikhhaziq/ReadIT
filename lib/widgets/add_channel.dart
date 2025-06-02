import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readit/models/category.dart';
import 'package:readit/providers/category_providers.dart';
import 'package:readit/providers/feed_preview_provider.dart';
import 'package:readit/providers/feed_saver_provider.dart';
import 'package:readit/viewmodels/home_viewmodel.dart';
import 'package:readit/widgets/add_category.dart';
import 'package:readit/widgets/dynamic_network_image.dart';

class AddChannel extends ConsumerStatefulWidget {
  const AddChannel({super.key});

  @override
  ConsumerState<AddChannel> createState() => _AddChannelState();
}

class _AddChannelState extends ConsumerState<AddChannel> {
  late TextEditingController channelController;
  bool loading = false;
  IsarCategory? category;

  @override
  void initState() {
    super.initState();
    channelController = TextEditingController();
  }

  @override
  void dispose() {
    channelController.dispose();
    super.dispose();
  }

  searchFeed(String value) async {
    setState(() {
      loading = true;
    });
    await ref.read(feedPreviewProvider.notifier).load(value);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final channel = ref.watch(feedPreviewProvider);
    return channel.when(
      data: (channel) {
        if (channel == null) {
          return AlertDialog(
            title: Text("Add Feed"),
            content: TextField(
              controller: channelController,
              autofocus: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).colorScheme.primaryContainer,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(25),
                ),
                hintText: 'Feed Url',
              ),
              onSubmitted: (value) async => await searchFeed(value),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: loading
                    ? null
                    : () async => await searchFeed(channelController.text),

                child: Text("Search"),
              ),
            ],
          );
        }
        return AlertDialog(
          icon: Column(
            children: [
              if (channel.image != null)
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 50, maxHeight: 50),
                  child: DynamicNetworkImage(channel.image!),
                ),
            ],
          ),
          title: Text(channel.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Category",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 40,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,

                  children: [
                    ...?ref
                        .watch(allCategoriesProvider)
                        .whenOrNull(
                          data: (data) => data
                              .map(
                                (chip) => FilledButton.icon(
                                  icon: category == chip
                                      ? Icon(Icons.check)
                                      : null,
                                  iconAlignment: IconAlignment.start,

                                  style: ButtonStyle(
                                    padding: WidgetStatePropertyAll(
                                      EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 8,
                                      ),
                                    ),
                                    backgroundColor: WidgetStatePropertyAll(
                                      category == chip
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                          : Theme.of(
                                              context,
                                            ).colorScheme.secondaryFixedDim,
                                    ),
                                    elevation: WidgetStatePropertyAll(0),
                                  ),
                                  label: Text(
                                    chip.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: category == chip
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary
                                              : Theme.of(
                                                  context,
                                                ).colorScheme.onSecondaryFixed,
                                        ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      category = category == chip ? null : chip;
                                    });
                                  },
                                ),
                              )
                              .toList(),
                        ),
                    IconButton.filledTonal(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) => AddCategory(),
                        );
                      },
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: category == null
                  ? null
                  : () async {
                      await ref
                          .read(feedSaverProvider.notifier)
                          .save(channel, category!);
                      await ref.read(homeViewModelProvider.notifier).refresh();
                      if (mounted) {
                        Navigator.pop(context);
                      }
                    },
              child: Text('Add'),
            ),
          ],
        );
      },
      error: (error, stackTrace) => SizedBox.shrink(),
      loading: () => SizedBox.shrink(),
    );
  }
}



// AlertDialog(
//       content: channel == null
//           ? 
//           : 
//       actions: [
//         
//         if (channel != null && category != null)
//           
//         if (channel == null)
//           TextButton(
//             onPressed: loading
//                 ? null
//                 : () async => await searchFeed(channelController.text),

//             child: Text("Search"),
//           ),
//       ],
//     );