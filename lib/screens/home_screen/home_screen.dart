import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readit/screens/home_screen/custom_drawer.dart';
import 'package:readit/screens/home_screen/home_screen_view_model.dart';
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
  bool _completed = false;

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
        !loadingMore &&
        !_completed) {
      setState(() => loadingMore = true);
      _completed = await ref
          .read(homeScreenViewModelProvider.notifier)
          .fetchMore();
      setState(() => loadingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(title: Text("Home")),
      drawer: CustomDrawer(),

      body: ref
          .watch(homeScreenViewModelProvider)
          .when(
            data: (articles) {
              return ListView.separated(
                key: const PageStorageKey<String>('homeFeedList'),
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                itemCount: articles.length + (loadingMore ? 1 : 0),
                separatorBuilder: (context, index) => SizedBox(height: 8),
                itemBuilder: (context, index) {
                  if (index == articles.length) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final article = articles[index];
                  return ArticleTile(article: article);
                },
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
