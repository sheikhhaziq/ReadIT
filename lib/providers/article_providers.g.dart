// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$articleWithChannelByIdHash() =>
    r'960d3119cbe36ad47814d7bc56b085e3d52cc338';

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

/// See also [articleWithChannelById].
@ProviderFor(articleWithChannelById)
const articleWithChannelByIdProvider = ArticleWithChannelByIdFamily();

/// See also [articleWithChannelById].
class ArticleWithChannelByIdFamily
    extends Family<AsyncValue<List<ArticleWithChannel>>> {
  /// See also [articleWithChannelById].
  const ArticleWithChannelByIdFamily();

  /// See also [articleWithChannelById].
  ArticleWithChannelByIdProvider call(
    int channelId,
    int offset,
    int limit,
  ) {
    return ArticleWithChannelByIdProvider(
      channelId,
      offset,
      limit,
    );
  }

  @override
  ArticleWithChannelByIdProvider getProviderOverride(
    covariant ArticleWithChannelByIdProvider provider,
  ) {
    return call(
      provider.channelId,
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
  String? get name => r'articleWithChannelByIdProvider';
}

/// See also [articleWithChannelById].
class ArticleWithChannelByIdProvider
    extends AutoDisposeFutureProvider<List<ArticleWithChannel>> {
  /// See also [articleWithChannelById].
  ArticleWithChannelByIdProvider(
    int channelId,
    int offset,
    int limit,
  ) : this._internal(
          (ref) => articleWithChannelById(
            ref as ArticleWithChannelByIdRef,
            channelId,
            offset,
            limit,
          ),
          from: articleWithChannelByIdProvider,
          name: r'articleWithChannelByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$articleWithChannelByIdHash,
          dependencies: ArticleWithChannelByIdFamily._dependencies,
          allTransitiveDependencies:
              ArticleWithChannelByIdFamily._allTransitiveDependencies,
          channelId: channelId,
          offset: offset,
          limit: limit,
        );

  ArticleWithChannelByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.channelId,
    required this.offset,
    required this.limit,
  }) : super.internal();

  final int channelId;
  final int offset;
  final int limit;

  @override
  Override overrideWith(
    FutureOr<List<ArticleWithChannel>> Function(
            ArticleWithChannelByIdRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ArticleWithChannelByIdProvider._internal(
        (ref) => create(ref as ArticleWithChannelByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        channelId: channelId,
        offset: offset,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ArticleWithChannel>> createElement() {
    return _ArticleWithChannelByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ArticleWithChannelByIdProvider &&
        other.channelId == channelId &&
        other.offset == offset &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, channelId.hashCode);
    hash = _SystemHash.combine(hash, offset.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ArticleWithChannelByIdRef
    on AutoDisposeFutureProviderRef<List<ArticleWithChannel>> {
  /// The parameter `channelId` of this provider.
  int get channelId;

  /// The parameter `offset` of this provider.
  int get offset;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _ArticleWithChannelByIdProviderElement
    extends AutoDisposeFutureProviderElement<List<ArticleWithChannel>>
    with ArticleWithChannelByIdRef {
  _ArticleWithChannelByIdProviderElement(super.provider);

  @override
  int get channelId => (origin as ArticleWithChannelByIdProvider).channelId;
  @override
  int get offset => (origin as ArticleWithChannelByIdProvider).offset;
  @override
  int get limit => (origin as ArticleWithChannelByIdProvider).limit;
}

String _$markReadArticleHash() => r'cb6d5935daca674e9d14733d38a40e2374de97ba';

/// See also [markReadArticle].
@ProviderFor(markReadArticle)
const markReadArticleProvider = MarkReadArticleFamily();

/// See also [markReadArticle].
class MarkReadArticleFamily extends Family<AsyncValue<void>> {
  /// See also [markReadArticle].
  const MarkReadArticleFamily();

  /// See also [markReadArticle].
  MarkReadArticleProvider call(
    int articleId,
  ) {
    return MarkReadArticleProvider(
      articleId,
    );
  }

  @override
  MarkReadArticleProvider getProviderOverride(
    covariant MarkReadArticleProvider provider,
  ) {
    return call(
      provider.articleId,
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
  String? get name => r'markReadArticleProvider';
}

/// See also [markReadArticle].
class MarkReadArticleProvider extends AutoDisposeFutureProvider<void> {
  /// See also [markReadArticle].
  MarkReadArticleProvider(
    int articleId,
  ) : this._internal(
          (ref) => markReadArticle(
            ref as MarkReadArticleRef,
            articleId,
          ),
          from: markReadArticleProvider,
          name: r'markReadArticleProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$markReadArticleHash,
          dependencies: MarkReadArticleFamily._dependencies,
          allTransitiveDependencies:
              MarkReadArticleFamily._allTransitiveDependencies,
          articleId: articleId,
        );

  MarkReadArticleProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.articleId,
  }) : super.internal();

  final int articleId;

  @override
  Override overrideWith(
    FutureOr<void> Function(MarkReadArticleRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MarkReadArticleProvider._internal(
        (ref) => create(ref as MarkReadArticleRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        articleId: articleId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _MarkReadArticleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MarkReadArticleProvider && other.articleId == articleId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, articleId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MarkReadArticleRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `articleId` of this provider.
  int get articleId;
}

class _MarkReadArticleProviderElement
    extends AutoDisposeFutureProviderElement<void> with MarkReadArticleRef {
  _MarkReadArticleProviderElement(super.provider);

  @override
  int get articleId => (origin as MarkReadArticleProvider).articleId;
}

String _$articleWithChannelHash() =>
    r'db5f2713411a0caeb80ca0b1844f350fd945c29b';

/// See also [articleWithChannel].
@ProviderFor(articleWithChannel)
const articleWithChannelProvider = ArticleWithChannelFamily();

/// See also [articleWithChannel].
class ArticleWithChannelFamily
    extends Family<AsyncValue<List<ArticleWithChannel>>> {
  /// See also [articleWithChannel].
  const ArticleWithChannelFamily();

  /// See also [articleWithChannel].
  ArticleWithChannelProvider call(
    int offset,
    int limit,
  ) {
    return ArticleWithChannelProvider(
      offset,
      limit,
    );
  }

  @override
  ArticleWithChannelProvider getProviderOverride(
    covariant ArticleWithChannelProvider provider,
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
  String? get name => r'articleWithChannelProvider';
}

/// See also [articleWithChannel].
class ArticleWithChannelProvider
    extends AutoDisposeFutureProvider<List<ArticleWithChannel>> {
  /// See also [articleWithChannel].
  ArticleWithChannelProvider(
    int offset,
    int limit,
  ) : this._internal(
          (ref) => articleWithChannel(
            ref as ArticleWithChannelRef,
            offset,
            limit,
          ),
          from: articleWithChannelProvider,
          name: r'articleWithChannelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$articleWithChannelHash,
          dependencies: ArticleWithChannelFamily._dependencies,
          allTransitiveDependencies:
              ArticleWithChannelFamily._allTransitiveDependencies,
          offset: offset,
          limit: limit,
        );

  ArticleWithChannelProvider._internal(
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
    FutureOr<List<ArticleWithChannel>> Function(ArticleWithChannelRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ArticleWithChannelProvider._internal(
        (ref) => create(ref as ArticleWithChannelRef),
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
    return _ArticleWithChannelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ArticleWithChannelProvider &&
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
mixin ArticleWithChannelRef
    on AutoDisposeFutureProviderRef<List<ArticleWithChannel>> {
  /// The parameter `offset` of this provider.
  int get offset;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _ArticleWithChannelProviderElement
    extends AutoDisposeFutureProviderElement<List<ArticleWithChannel>>
    with ArticleWithChannelRef {
  _ArticleWithChannelProviderElement(super.provider);

  @override
  int get offset => (origin as ArticleWithChannelProvider).offset;
  @override
  int get limit => (origin as ArticleWithChannelProvider).limit;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
