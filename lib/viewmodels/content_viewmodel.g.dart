// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$contentViewmodelHash() => r'e027f904aa52e302d9e62ae736af8b82833c8a39';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$ContentViewmodel
    extends BuildlessAutoDisposeAsyncNotifier<String> {
  late final String url;

  FutureOr<String> build(
    String url,
  );
}

/// See also [ContentViewmodel].
@ProviderFor(ContentViewmodel)
const contentViewmodelProvider = ContentViewmodelFamily();

/// See also [ContentViewmodel].
class ContentViewmodelFamily extends Family<AsyncValue<String>> {
  /// See also [ContentViewmodel].
  const ContentViewmodelFamily();

  /// See also [ContentViewmodel].
  ContentViewmodelProvider call(
    String url,
  ) {
    return ContentViewmodelProvider(
      url,
    );
  }

  @override
  ContentViewmodelProvider getProviderOverride(
    covariant ContentViewmodelProvider provider,
  ) {
    return call(
      provider.url,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'contentViewmodelProvider';
}

/// See also [ContentViewmodel].
class ContentViewmodelProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ContentViewmodel, String> {
  /// See also [ContentViewmodel].
  ContentViewmodelProvider(
    String url,
  ) : this._internal(
          () => ContentViewmodel()..url = url,
          from: contentViewmodelProvider,
          name: r'contentViewmodelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$contentViewmodelHash,
          dependencies: ContentViewmodelFamily._dependencies,
          allTransitiveDependencies:
              ContentViewmodelFamily._allTransitiveDependencies,
          url: url,
        );

  ContentViewmodelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.url,
  }) : super.internal();

  final String url;

  @override
  FutureOr<String> runNotifierBuild(
    covariant ContentViewmodel notifier,
  ) {
    return notifier.build(
      url,
    );
  }

  @override
  Override overrideWith(ContentViewmodel Function() create) {
    return ProviderOverride(
      origin: this,
      override: ContentViewmodelProvider._internal(
        () => create()..url = url,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        url: url,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ContentViewmodel, String>
      createElement() {
    return _ContentViewmodelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ContentViewmodelProvider && other.url == url;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, url.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ContentViewmodelRef on AutoDisposeAsyncNotifierProviderRef<String> {
  /// The parameter `url` of this provider.
  String get url;
}

class _ContentViewmodelProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ContentViewmodel, String>
    with ContentViewmodelRef {
  _ContentViewmodelProviderElement(super.provider);

  @override
  String get url => (origin as ContentViewmodelProvider).url;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
