// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_channel_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$articleWithChannelPageHash() =>
    r'c41b434e085d09c3e863920d4b7153648ead08f5';

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

/// See also [articleWithChannelPage].
@ProviderFor(articleWithChannelPage)
const articleWithChannelPageProvider = ArticleWithChannelPageFamily();

/// See also [articleWithChannelPage].
class ArticleWithChannelPageFamily
    extends Family<AsyncValue<List<ArticleWithChannel>>> {
  /// See also [articleWithChannelPage].
  const ArticleWithChannelPageFamily();

  /// See also [articleWithChannelPage].
  ArticleWithChannelPageProvider call(
    int offset,
    int limit,
  ) {
    return ArticleWithChannelPageProvider(
      offset,
      limit,
    );
  }

  @override
  ArticleWithChannelPageProvider getProviderOverride(
    covariant ArticleWithChannelPageProvider provider,
  ) {
    return call(
      provider.offset,
      provider.limit,
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
  String? get name => r'articleWithChannelPageProvider';
}

/// See also [articleWithChannelPage].
class ArticleWithChannelPageProvider
    extends AutoDisposeFutureProvider<List<ArticleWithChannel>> {
  /// See also [articleWithChannelPage].
  ArticleWithChannelPageProvider(
    int offset,
    int limit,
  ) : this._internal(
          (ref) => articleWithChannelPage(
            ref as ArticleWithChannelPageRef,
            offset,
            limit,
          ),
          from: articleWithChannelPageProvider,
          name: r'articleWithChannelPageProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$articleWithChannelPageHash,
          dependencies: ArticleWithChannelPageFamily._dependencies,
          allTransitiveDependencies:
              ArticleWithChannelPageFamily._allTransitiveDependencies,
          offset: offset,
          limit: limit,
        );

  ArticleWithChannelPageProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.offset,
    required this.limit,
  }) : super.internal();

  final int offset;
  final int limit;

  @override
  Override overrideWith(
    FutureOr<List<ArticleWithChannel>> Function(
            ArticleWithChannelPageRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ArticleWithChannelPageProvider._internal(
        (ref) => create(ref as ArticleWithChannelPageRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        offset: offset,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ArticleWithChannel>> createElement() {
    return _ArticleWithChannelPageProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ArticleWithChannelPageProvider &&
        other.offset == offset &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, offset.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ArticleWithChannelPageRef
    on AutoDisposeFutureProviderRef<List<ArticleWithChannel>> {
  /// The parameter `offset` of this provider.
  int get offset;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _ArticleWithChannelPageProviderElement
    extends AutoDisposeFutureProviderElement<List<ArticleWithChannel>>
    with ArticleWithChannelPageRef {
  _ArticleWithChannelPageProviderElement(super.provider);

  @override
  int get offset => (origin as ArticleWithChannelPageProvider).offset;
  @override
  int get limit => (origin as ArticleWithChannelPageProvider).limit;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
