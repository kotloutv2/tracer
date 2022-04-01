/// Based on code provided in
/// https://github.com/PhilipsHue/flutter_reactive_ble/tree/master/example/lib/src/ble

import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

// const _peripheralId = 'Echo RVMS';
final _serviceUuid = Uuid.parse('6e400001-b5a3-f393-e0a9-e50e24dcca9e');
final _characteristicUuids = [
  Uuid.parse('6e400003-b5a3-f393-e0a9-e50e24dcca9e')
];

class BleService extends ChangeNotifier {
  final _bleManager = FlutterReactiveBle();

  // Scanning
  var scanResults = <String, DiscoveredDevice>{};
  StreamSubscription<DiscoveredDevice>? _scanStream;
  bool get isScanning => _scanStream != null;

  // Device Connection
  StreamSubscription<ConnectionStateUpdate>? _connection;
  Stream<List<int>>? dataStream;

  DeviceConnectionState deviceState = DeviceConnectionState.disconnected;
  String? connectedDevice;

  // Host state
  late BleStatus hostStatus;

  BleService() {
    hostStatus = _bleManager.status;
    _bleManager.statusStream.listen((status) {
      hostStatus = status;
      log('BLE Subsystem changed status to: $status',
          name: 'tracer.ble.statusStream');
      notifyListeners();
    });
  }

  void startScan() {
    _scanStream = _bleManager
        .scanForDevices(withServices: [_serviceUuid]).listen((device) {
      scanResults[device.id] = device;
      notifyListeners();
    }, onError: (e) {
      log('Scanning for devices errored: $e', name: 'tracer.ble.scan');
    });
  }

  Future<void> stopScan() async {
    log('Stopping scan', name: 'tracer.ble.scan');

    await _scanStream?.cancel().then((_) {
      _scanStream = null;
    });
    notifyListeners();
  }

  void connectionStateHandler(ConnectionStateUpdate update) {
    log('Device ${update.deviceId} connection state changed to: ${update.connectionState}',
        name: 'tracer.ble.connectionStatus');
    deviceState = update.connectionState;

    if (deviceState == DeviceConnectionState.connected) {
      connectedDevice = update.deviceId;
    }

    notifyListeners();
  }

  Future<void> connect(DiscoveredDevice device) async {
    _connection = _bleManager
        .connectToDevice(
            id: device.id,
            servicesWithCharacteristicsToDiscover: {
              _serviceUuid: _characteristicUuids
            },
            connectionTimeout: const Duration(seconds: 5))
        .listen(connectionStateHandler);

    dataStream = _bleManager.subscribeToCharacteristic(QualifiedCharacteristic(
        characteristicId: _characteristicUuids[0],
        serviceId: _serviceUuid,
        deviceId: device.id));

    notifyListeners();
  }

  void disconnect() {
    if (_connection != null) {
      try {
        _connection?.cancel();
        _connection = null;
        connectedDevice = null;
        dataStream?.drain();
        notifyListeners();
      } on Exception catch (e, _) {
        log('Error disconnecting from device: $e',
            name: 'tracer.ble.disconnect');
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scanStream?.cancel();
    _connection?.cancel();
  }
}
