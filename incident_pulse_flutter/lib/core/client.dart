import 'package:flutter/foundation.dart';
import 'package:incident_pulse_client/incident_pulse_client.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

late Client client;

/// Initializes the global Serverpod Client connection
void initServerpodClient({String? serverUrl}) {
  String defaultHost;
  if (kIsWeb) {
    final baseUri = Uri.base;
    if (baseUri.host.isNotEmpty && baseUri.scheme.startsWith('http')) {
      final portSuffix = (baseUri.hasPort && baseUri.port != 80 && baseUri.port != 443)
          ? ':${baseUri.port}'
          : '';
      defaultHost = '${baseUri.scheme}://${baseUri.host}$portSuffix/';
    } else {
      defaultHost = 'http://localhost:8080/';
    }
  } else {
    defaultHost = defaultTargetPlatform == TargetPlatform.android
        ? 'http://10.0.2.2:8080/'
        : 'http://localhost:8080/';
  }

  client = Client(serverUrl ?? defaultHost)
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authKeyProvider = FlutterAuthenticationKeyManager();
}
