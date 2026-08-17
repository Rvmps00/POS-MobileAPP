// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ShiftNotifier)
final shiftProvider = ShiftNotifierProvider._();

final class ShiftNotifierProvider
    extends $AsyncNotifierProvider<ShiftNotifier, ShiftModel?> {
  ShiftNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shiftProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shiftNotifierHash();

  @$internal
  @override
  ShiftNotifier create() => ShiftNotifier();
}

String _$shiftNotifierHash() => r'b3dbd525747963165ae7409c8d333104e9e8906a';

abstract class _$ShiftNotifier extends $AsyncNotifier<ShiftModel?> {
  FutureOr<ShiftModel?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ShiftModel?>, ShiftModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ShiftModel?>, ShiftModel?>,
              AsyncValue<ShiftModel?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
