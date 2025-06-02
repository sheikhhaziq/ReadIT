import 'package:isar/isar.dart';

import 'channel.dart';

part 'category.g.dart';

@collection
class IsarCategory {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String name;
  final channels = IsarLinks<IsarChannel>();
}
