import 'package:isar/isar.dart';

import 'channel.dart';

part 'category.g.dart';

@collection
class Category {
  Id id = Isar.autoIncrement;

  late String name;

  final channels = IsarLinks<Channel>();
}
