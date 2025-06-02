import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:readit/models/article.dart';
import 'package:readit/viewmodels/content_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

class ContentScreen extends ConsumerWidget {
  const ContentScreen({super.key, required this.article});
  final IsarArticle article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await launchUrl(Uri.parse(article.link!));
            },
            icon: Icon(Icons.open_in_browser),
          ),
        ],
      ),
      body: ref
          .watch(contentViewmodelProvider(article.link!))
          .when(
            data: (htmlContent) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: HtmlWidget(
                    htmlContent,
                    customStylesBuilder: (element) {
                      if (element.localName == 'img') {
                        return {'border-radius': '10px'};
                      }
                      return null;
                    },
                  ),
                ),
              );
            },
            error: (e, s) => Center(
              child: Column(children: [Text(e.toString()), Text(s.toString())]),
            ),
            loading: () => Center(child: CircularProgressIndicator()),
          ),
    );
  }
}
