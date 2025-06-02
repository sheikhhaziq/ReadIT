import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/isar_service.dart';

part 'isar_provider.g.dart';

@Riverpod(keepAlive: true)
Future<Isar> isarInstance(Ref ref) async {
  return getIsarInstance();
}
