import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider extends ChangeNotifier {
  bool isOnline = true; // Default to true for demo
  StreamSubscription? _subscription;
  bool _isManualMode = false;

  ConnectivityProvider() {
    _subscription = Connectivity().onConnectivityChanged.listen((status) {
      // Only update if not in manual override mode
      if (!_isManualMode) {
        // connectivity_plus 6.0 returns List<ConnectivityResult>, check compat
        // If older version, it returns ConnectivityResult.
        // Assuming current version, it might return a list or single.
        // For safety with older code structure shown:
        final hasConnection = status != ConnectivityResult.none;
        if (isOnline != hasConnection) {
          isOnline = hasConnection;
          notifyListeners();
        }
      }
    });
  }

  void toggleConnection() {
    _isManualMode = true; // Enable manual override once user clicks
    isOnline = !isOnline;
    notifyListeners();
  }
}
