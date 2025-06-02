import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:readit/providers/channel_providers.dart';
import 'package:readit/viewmodels/channel_viewmodel.dart';
import 'package:readit/widgets/article_tile.dart';

class ChannelScreen extends ConsumerStatefulWidget {
  const ChannelScreen({
    super.key,
    required this.channelId,
    required this.title,
  });
  final Id channelId;
  final String title;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends ConsumerState<ChannelScreen> {
  late ScrollController _scrollController;
  bool loadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  scrollListener() async {
    if (!_scrollController.hasClients ||
        _scrollController.position.maxScrollExtent == 0) {
      return;
    }
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !loadingMore) {
      setState(() => loadingMore = true);
      await ref
          .read(channelViewmodelProvider(widget.channelId).notifier)
          .loadMore();

      setState(() => loadingMore = false);
    }
  }

  Future<void> refreshArticles() async {
    await ref.read(syncChannelProvider(widget.channelId).future);
    await ref
        .read(channelViewmodelProvider(widget.channelId).notifier)
        .refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(title: Text(widget.title)),

      body: ref
          .watch(channelViewmodelProvider(widget.channelId))
          .when(
            data: (articles) {
              return RefreshIndicator(
                onRefresh: refreshArticles,
                child: ListView.separated(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  itemCount: articles.length,
                  separatorBuilder: (context, index) => SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return ArticleTile(
                      articleWithChannel: article,
                      onTap: (article) async {
                        if (!article.isRead) {
                          await ref
                              .read(
                                channelViewmodelProvider(
                                  widget.channelId,
                                ).notifier,
                              )
                              .markArticleAsRead(article.id);
                        }
                      },
                    );
                  },
                ),
              );
            },
            error: (e, s) => Center(child: Text(e.toString())),
            loading: () => Center(child: CircularProgressIndicator()),
          ),
    );
  }
}
