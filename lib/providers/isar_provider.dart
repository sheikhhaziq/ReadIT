import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:readit/models/category.dart';
import 'package:readit/models/channel.dart';
import 'package:readit/models/feed_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'isar_provider.g.dart';

@Riverpod(keepAlive: true)
Future<Isar> isar(Ref ref) async {
  final dir = await getApplicationDocumentsDirectory();
  return await Isar.open([
    ChannelSchema,
    FeedItemSchema,
    CategorySchema,
  ], directory: dir.path);
}
