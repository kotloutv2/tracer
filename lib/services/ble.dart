import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

const _PERIPHERAL_ID = 'Echo RVMS';
final _SERVICE_UUID = Uuid.parse('6e400001-b5a3-f393-e0a9-e50e24dcca9e');
final _CHARACTERISTIC_UUIDS = [
  Uuid.parse('6e400003-b5a3-f393-e0a9-e50e24dcca9e')
];

class BleService {
  static BleService? _bleService;

  FlutterReactiveBle _bleManager = FlutterReactiveBle();

  late Stream<DiscoveredDevice> _scanStream;

  var connectionStatus = DeviceConnectionState.disconnected;

  final StreamController<List<int>> _messageStream =
      StreamController.broadcast();

  factory BleService() {
    return _bleService ??= _bleService = BleService._();
  }

  /// Private constructor
  BleService._() {
    _scanStream = _bleManager.scanForDevices(
        withServices: [_SERVICE_UUID], requireLocationServicesEnabled: true);
  }

  Stream<DiscoveredDevice> startScan() async* {
    await for (final device in _scanStream) {
      if (device.name == _PERIPHERAL_ID) {
        yield device;
      }
    }
  }

  void connect(DiscoveredDevice device) {
    final characteristic = QualifiedCharacteristic(
        serviceId: _SERVICE_UUID,
        characteristicId: _CHARACTERISTIC_UUIDS[0],
        deviceId: device.id);

    connectionStatus = DeviceConnectionState.connecting;

    _bleManager.connectToDevice(
      id: device.id,
      servicesWithCharacteristicsToDiscover: {
        _SERVICE_UUID: _CHARACTERISTIC_UUIDS
      },
    ).listen(connectionStateUpdate);

    _bleManager.subscribeToCharacteristic(characteristic).listen((event) {
      _messageStream.add(event);
      print(String.fromCharCodes(event));
    });
  }

  void connectionStateUpdate(ConnectionStateUpdate update) {
    connectionStatus = update.connectionState;
  }
}
