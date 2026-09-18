import 'package:flutter/foundation.dart';
import 'package:incident_pulse_client/incident_pulse_client.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

late Client client;

/// Initializes the global Serverpod Client connection
void initServerpodClient({String? serverUrl}) {
  final defaultHost = kIsWeb
      ? 'http://localhost:8080/'
      : (defaultTargetPlatform == TargetPlatform.android
          ? 'http://10.0.2.2:8080/'
          : 'http://localhost:8080/');

  client = Client(
    serverUrl ?? defaultHost,
    authenticationKeyManager: FlutterAuthenticationKeyManager(),
  )..connectivityMonitor = FlutterConnectivityMonitor();
}
