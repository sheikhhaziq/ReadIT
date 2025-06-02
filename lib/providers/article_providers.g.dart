// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$articlesByChannelHash() => r'109edcc83b74526c48ea1339cc2c75d43acacb4c';

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

/// See also [articlesByChannel].
@ProviderFor(articlesByChannel)
const articlesByChannelProvider = ArticlesByChannelFamily();

/// See also [articlesByChannel].
class ArticlesByChannelFamily extends Family<AsyncValue<List<IsarArticle>>> {
  /// See also [articlesByChannel].
  const ArticlesByChannelFamily();

  /// See also [articlesByChannel].
  ArticlesByChannelProvider call(
    int channelId,
  ) {
    return ArticlesByChannelProvider(
      channelId,
    );
  }

  @override
  ArticlesByChannelProvider getProviderOverride(
    covariant ArticlesByChannelProvider provider,
  ) {
    return call(
      provider.channelId,
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
  String? get name => r'articlesByChannelProvider';
}

/// See also [articlesByChannel].
class ArticlesByChannelProvider
    extends AutoDisposeFutureProvider<List<IsarArticle>> {
  /// See also [articlesByChannel].
  ArticlesByChannelProvider(
    int channelId,
  ) : this._internal(
          (ref) => articlesByChannel(
            ref as ArticlesByChannelRef,
            channelId,
          ),
          from: articlesByChannelProvider,
          name: r'articlesByChannelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$articlesByChannelHash,
          dependencies: ArticlesByChannelFamily._dependencies,
          allTransitiveDependencies:
              ArticlesByChannelFamily._allTransitiveDependencies,
          channelId: channelId,
        );

  ArticlesByChannelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.channelId,
  }) : super.internal();

  final int channelId;

  @override
  Override overrideWith(
    FutureOr<List<IsarArticle>> Function(ArticlesByChannelRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ArticlesByChannelProvider._internal(
        (ref) => create(ref as ArticlesByChannelRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        channelId: channelId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<IsarArticle>> createElement() {
    return _ArticlesByChannelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ArticlesByChannelProvider && other.channelId == channelId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, channelId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ArticlesByChannelRef on AutoDisposeFutureProviderRef<List<IsarArticle>> {
  /// The parameter `channelId` of this provider.
  int get channelId;
}

class _ArticlesByChannelProviderElement
    extends AutoDisposeFutureProviderElement<List<IsarArticle>>
    with ArticlesByChannelRef {
  _ArticlesByChannelProviderElement(super.provider);

  @override
  int get channelId => (origin as ArticlesByChannelProvider).channelId;
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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
