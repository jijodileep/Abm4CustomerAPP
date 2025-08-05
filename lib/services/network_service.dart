import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

enum NetworkStatus { connected, disconnected, unknown }

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  NetworkService._internal();

  final StreamController<NetworkStatus> _networkStatusController =
      StreamController<NetworkStatus>.broadcast();

  Stream<NetworkStatus> get networkStatusStream =>
      _networkStatusController.stream;

  NetworkStatus _currentStatus = NetworkStatus.unknown;
  NetworkStatus get currentStatus => _currentStatus;

  Timer? _connectivityTimer;

  /// Initialize network monitoring
  void initialize() {
    _startNetworkMonitoring();
  }

  /// Start monitoring network connectivity
  void _startNetworkMonitoring() {
    // Check connectivity every 10 seconds
    _connectivityTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _checkConnectivity(),
    );
    
    // Initial check
    _checkConnectivity();
  }

  /// Check network connectivity
  Future<void> _checkConnectivity() async {
    try {
      final result = await _hasNetworkConnection();
      final newStatus = result ? NetworkStatus.connected : NetworkStatus.disconnected;
      
      if (newStatus != _currentStatus) {
        _currentStatus = newStatus;
        _networkStatusController.add(_currentStatus);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Network check error: $e');
      }
      _currentStatus = NetworkStatus.unknown;
      _networkStatusController.add(_currentStatus);
    }
  }

  /// Check if device has network connection
  Future<bool> _hasNetworkConnection() async {
    try {
      // Try to lookup a reliable host
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Network connectivity check failed: $e');
      }
      return false;
    }
  }

  /// Check connectivity with custom host
  Future<bool> hasInternetConnection({String host = 'google.com'}) async {
    try {
      final result = await InternetAddress.lookup(host);
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// Check if connected to internet (one-time check)
  Future<bool> isConnected() async {
    return await _hasNetworkConnection();
  }

  /// Dispose resources
  void dispose() {
    _connectivityTimer?.cancel();
    _networkStatusController.close();
  }
}

/// Network exception for handling connectivity issues
class NetworkException implements Exception {
  final String message;
  final NetworkStatus status;

  NetworkException(this.message, this.status);

  @override
  String toString() => 'NetworkException: $message';
}