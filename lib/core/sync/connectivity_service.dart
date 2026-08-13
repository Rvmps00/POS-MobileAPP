import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides real connectivity state by combining connectivity_plus
/// with an actual HTTP ping to verify internet access.
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final _controller = StreamController<bool>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _lastKnownState = true;

  ConnectivityService() {
    _subscription = _connectivity.onConnectivityChanged.listen((results) async {
      final hasConnection = !results.contains(ConnectivityResult.none);
      if (hasConnection) {
        // Verify with actual HTTP ping
        final isReachable = await _checkInternetAccess();
        _updateState(isReachable);
      } else {
        _updateState(false);
      }
    });
    // Check immediately on creation
    checkNow();
  }

  Stream<bool> get onlineStream => _controller.stream;
  bool get isOnline => _lastKnownState;

  void _updateState(bool isOnline) {
    if (_lastKnownState != isOnline) {
      _lastKnownState = isOnline;
      _controller.add(isOnline);
    }
  }

  Future<bool> checkNow() async {
    try {
      final results = await _connectivity.checkConnectivity();
      if (results.contains(ConnectivityResult.none)) {
        _updateState(false);
        return false;
      }
      final isReachable = await _checkInternetAccess();
      _updateState(isReachable);
      return isReachable;
    } catch (_) {
      _updateState(false);
      return false;
    }
  }

  Future<bool> _checkInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}

// ─── Providers ───

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.onDispose(() => service.dispose());
  return service;
});

final isOnlineProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  // Emit initial state then stream updates
  return Stream.value(service.isOnline).asyncExpand(
    (initial) async* {
      yield initial;
      yield* service.onlineStream;
    },
  );
});
