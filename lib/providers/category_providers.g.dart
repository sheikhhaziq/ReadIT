// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allCategoriesWithChannelIdsHash() =>
    r'e6285a0ca3167624b28e02ae13f56dcd3d3dfe5c';

/// See also [allCategoriesWithChannelIds].
@ProviderFor(allCategoriesWithChannelIds)
final allCategoriesWithChannelIdsProvider =
    AutoDisposeStreamProvider<List<(IsarCategory, List<Id>)>>.internal(
  allCategoriesWithChannelIds,
  name: r'allCategoriesWithChannelIdsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allCategoriesWithChannelIdsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllCategoriesWithChannelIdsRef
    = AutoDisposeStreamProviderRef<List<(IsarCategory, List<Id>)>>;
String _$allCategoriesHash() => r'ec597881caeca4f9385ccddf20338ecbbe9667dd';

/// See also [allCategories].
@ProviderFor(allCategories)
final allCategoriesProvider =
    AutoDisposeStreamProvider<List<IsarCategory>>.internal(
  allCategories,
  name: r'allCategoriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allCategoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllCategoriesRef = AutoDisposeStreamProviderRef<List<IsarCategory>>;
String _$categoryControllerHash() =>
    r'c483adba5bf4affa01119c15349a6b6371a441fb';

/// See also [CategoryController].
@ProviderFor(CategoryController)
final categoryControllerProvider =
    AutoDisposeAsyncNotifierProvider<CategoryController, void>.internal(
  CategoryController.new,
  name: r'categoryControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$categoryControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CategoryController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
