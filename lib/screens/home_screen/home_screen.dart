import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readit/screens/home_screen/home_screen_view_model.dart';
import 'package:readit/widgets/add_category.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBody: true,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              snap: true,
              floating: true,
              expandedHeight: 100,
              flexibleSpace: FlexibleSpaceBar(title: Text("Home")),
            ),
          ];
        },
        body: ref
            .watch(homeScreenViewModelProvider)
            .when(
              data: (articles) {
                return ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return ListTile(title: Text(article.title));
                  },
                );
              },
              error: (e, s) => Center(child: Text(e.toString())),
              loading: () => Center(child: CircularProgressIndicator()),
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => AddCategory(),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
