import 'dart:io'; //InternetAddress utility
import 'dart:async'; //For StreamController/Stream

import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';

const CONNECTED_TIMER_DURATION = Duration(seconds: 15);
const DISCONNECTED_TIMER_DURATION = Duration(seconds: 2);

class ConnectionStatusSingleton {
  static final ConnectionStatusSingleton _singleton = new ConnectionStatusSingleton._internal();
  ConnectionStatusSingleton._internal();

  static ConnectionStatusSingleton getInstance() => _singleton;

  bool hasConnection = true;
  Timer _timer;

  StreamController connectionChangeController = StreamController.broadcast();

  final Connectivity _connectivity = Connectivity();

  void initialize() async {
    try {
      final result = await _connectivity.checkConnectivity();
      checkConnection(result);
    } on PlatformException catch (e) {
      print(e.toString());
    }
    _connectivity.onConnectivityChanged.listen(_connectionChange);
  }

  Stream get connectionChange => connectionChangeController.stream;

  //A clean up method to close our StreamController
  //Because this is meant to exist through the entire application life cycle this isn't really an issue
  void dispose() {
    connectionChangeController.close();
  }

  //flutter_connectivity's listener
  void _connectionChange(ConnectivityResult result) {
    checkConnection(result);
  }

  //The test to actually see if there is a connection
  checkConnection([ConnectivityResult result]) {
    if (result == ConnectivityResult.none) {
      if (hasConnection != false) {
        hasConnection = false;
        connectionChangeController.add(hasConnection);
      }
    }

    if (_timer != null) {
      _timer.cancel();
    }

    final duration = hasConnection ? CONNECTED_TIMER_DURATION : DISCONNECTED_TIMER_DURATION;
    _timer = Timer.periodic(duration, _timerCallback);
  }

  _timerCallback(_) async {
    bool previousConnection = hasConnection;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }

    //The connection status changed send out an update to all listeners
    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }

    return hasConnection;
  }
}
