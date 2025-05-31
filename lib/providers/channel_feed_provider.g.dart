// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_feed_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$channelFeedItemsHash() => r'df5062f4299e79f3b35c3a2c5a5df5f3a865e56f';

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

abstract class _$ChannelFeedItems
    extends BuildlessAutoDisposeAsyncNotifier<List<FeedItem>> {
  late final int channelId;

  FutureOr<List<FeedItem>> build(
    int channelId,
  );
}

/// See also [ChannelFeedItems].
@ProviderFor(ChannelFeedItems)
const channelFeedItemsProvider = ChannelFeedItemsFamily();

/// See also [ChannelFeedItems].
class ChannelFeedItemsFamily extends Family<AsyncValue<List<FeedItem>>> {
  /// See also [ChannelFeedItems].
  const ChannelFeedItemsFamily();

  /// See also [ChannelFeedItems].
  ChannelFeedItemsProvider call(
    int channelId,
  ) {
    return ChannelFeedItemsProvider(
      channelId,
    );
  }

  @override
  ChannelFeedItemsProvider getProviderOverride(
    covariant ChannelFeedItemsProvider provider,
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
  String? get name => r'channelFeedItemsProvider';
}

/// See also [ChannelFeedItems].
class ChannelFeedItemsProvider extends AutoDisposeAsyncNotifierProviderImpl<
    ChannelFeedItems, List<FeedItem>> {
  /// See also [ChannelFeedItems].
  ChannelFeedItemsProvider(
    int channelId,
  ) : this._internal(
          () => ChannelFeedItems()..channelId = channelId,
          from: channelFeedItemsProvider,
          name: r'channelFeedItemsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$channelFeedItemsHash,
          dependencies: ChannelFeedItemsFamily._dependencies,
          allTransitiveDependencies:
              ChannelFeedItemsFamily._allTransitiveDependencies,
          channelId: channelId,
        );

  ChannelFeedItemsProvider._internal(
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
  FutureOr<List<FeedItem>> runNotifierBuild(
    covariant ChannelFeedItems notifier,
  ) {
    return notifier.build(
      channelId,
    );
  }

  @override
  Override overrideWith(ChannelFeedItems Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChannelFeedItemsProvider._internal(
        () => create()..channelId = channelId,
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
  AutoDisposeAsyncNotifierProviderElement<ChannelFeedItems, List<FeedItem>>
      createElement() {
    return _ChannelFeedItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChannelFeedItemsProvider && other.channelId == channelId;
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
mixin ChannelFeedItemsRef
    on AutoDisposeAsyncNotifierProviderRef<List<FeedItem>> {
  /// The parameter `channelId` of this provider.
  int get channelId;
}

class _ChannelFeedItemsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ChannelFeedItems,
        List<FeedItem>> with ChannelFeedItemsRef {
  _ChannelFeedItemsProviderElement(super.provider);

  @override
  int get channelId => (origin as ChannelFeedItemsProvider).channelId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
