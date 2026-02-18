// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_mock_data.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mockNews)
final mockNewsProvider = MockNewsProvider._();

final class MockNewsProvider
    extends
        $FunctionalProvider<List<BentoItem>, List<BentoItem>, List<BentoItem>>
    with $Provider<List<BentoItem>> {
  MockNewsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mockNewsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mockNewsHash();

  @$internal
  @override
  $ProviderElement<List<BentoItem>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<BentoItem> create(Ref ref) {
    return mockNews(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<BentoItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<BentoItem>>(value),
    );
  }
}

String _$mockNewsHash() => r'0fb95ae28adcac491c32e56657426b4465d21a64';

@ProviderFor(mockEvents)
final mockEventsProvider = MockEventsProvider._();

final class MockEventsProvider
    extends
        $FunctionalProvider<List<BentoItem>, List<BentoItem>, List<BentoItem>>
    with $Provider<List<BentoItem>> {
  MockEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mockEventsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mockEventsHash();

  @$internal
  @override
  $ProviderElement<List<BentoItem>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<BentoItem> create(Ref ref) {
    return mockEvents(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<BentoItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<BentoItem>>(value),
    );
  }
}

String _$mockEventsHash() => r'd51e979c4e2eaff8eb8ff16cd83811cc50b63091';
