import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService instance = ConnectivityService._init();
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionStreamController = StreamController<bool>.broadcast();

  ConnectivityService._init() {
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      bool isOnline = results.any((result) => result != ConnectivityResult.none);
      _connectionStreamController.add(isOnline);
    });
  }

  Stream<bool> get connectionStream => _connectionStreamController.stream;

  Future<bool> isConnected() async {
    final results = await _connectivity.checkConnectivity();
    return results.any((result) => result != ConnectivityResult.none);
  }
}
