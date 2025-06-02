import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readit/providers/channel_providers.dart';
import 'package:readit/viewmodels/home_viewmodel.dart';
import 'package:readit/views/home_screen/custom_drawer.dart';
import 'package:readit/widgets/add_channel.dart';
import 'package:readit/widgets/article_tile.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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
      ref.read(homeViewModelProvider.notifier).loadMore();

      setState(() => loadingMore = false);
    }
  }

  Future<void> refreshArticles() async {
    await ref.read(syncAllChannelsProvider.future);
    await ref.read(homeViewModelProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(title: Text("All Feeds")),
      drawer: CustomDrawer(),

      body: ref
          .watch(homeViewModelProvider)
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
                    final articleWithChannel = articles[index];
                    return ArticleTile(
                      articleWithChannel: articleWithChannel,
                      onTap: (article) async {
                        if (!article.isRead) {
                          await ref
                              .read(homeViewModelProvider.notifier)
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (context) => AddChannel());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
