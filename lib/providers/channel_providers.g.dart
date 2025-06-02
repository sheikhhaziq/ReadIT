// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$channelWithUnreadCountHash() =>
    r'25f984ef6bd816a58d1c1893f03a904acdbf6359';

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

/// See also [channelWithUnreadCount].
@ProviderFor(channelWithUnreadCount)
const channelWithUnreadCountProvider = ChannelWithUnreadCountFamily();

/// See also [channelWithUnreadCount].
class ChannelWithUnreadCountFamily
    extends Family<AsyncValue<(IsarChannel, int)>> {
  /// See also [channelWithUnreadCount].
  const ChannelWithUnreadCountFamily();

  /// See also [channelWithUnreadCount].
  ChannelWithUnreadCountProvider call(
    int channelId,
  ) {
    return ChannelWithUnreadCountProvider(
      channelId,
    );
  }

  @override
  ChannelWithUnreadCountProvider getProviderOverride(
    covariant ChannelWithUnreadCountProvider provider,
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
  String? get name => r'channelWithUnreadCountProvider';
}

/// See also [channelWithUnreadCount].
class ChannelWithUnreadCountProvider
    extends AutoDisposeStreamProvider<(IsarChannel, int)> {
  /// See also [channelWithUnreadCount].
  ChannelWithUnreadCountProvider(
    int channelId,
  ) : this._internal(
          (ref) => channelWithUnreadCount(
            ref as ChannelWithUnreadCountRef,
            channelId,
          ),
          from: channelWithUnreadCountProvider,
          name: r'channelWithUnreadCountProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$channelWithUnreadCountHash,
          dependencies: ChannelWithUnreadCountFamily._dependencies,
          allTransitiveDependencies:
              ChannelWithUnreadCountFamily._allTransitiveDependencies,
          channelId: channelId,
        );

  ChannelWithUnreadCountProvider._internal(
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
    Stream<(IsarChannel, int)> Function(ChannelWithUnreadCountRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChannelWithUnreadCountProvider._internal(
        (ref) => create(ref as ChannelWithUnreadCountRef),
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
  AutoDisposeStreamProviderElement<(IsarChannel, int)> createElement() {
    return _ChannelWithUnreadCountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChannelWithUnreadCountProvider &&
        other.channelId == channelId;
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
mixin ChannelWithUnreadCountRef
    on AutoDisposeStreamProviderRef<(IsarChannel, int)> {
  /// The parameter `channelId` of this provider.
  int get channelId;
}

class _ChannelWithUnreadCountProviderElement
    extends AutoDisposeStreamProviderElement<(IsarChannel, int)>
    with ChannelWithUnreadCountRef {
  _ChannelWithUnreadCountProviderElement(super.provider);

  @override
  int get channelId => (origin as ChannelWithUnreadCountProvider).channelId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
