import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class LogScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LogViewState();
  }
}

class LogViewState extends State<LogScreen> {
  StreamController<String>? messageStream;
  List<String> messages = [];
  final bleManager = FlutterReactiveBle();

  late String deviceId;

  @override
  void initState() {
    super.initState();
    messageStream = StreamController.broadcast();

    messageStream?.stream.listen((msg) => setState(() => messages.add(msg)));

    // Set up ble device

    bleManager.scanForDevices(withServices: [
      Uuid.parse('6e400001-b5a3-f393-e0a9-e50e24dcca9e')
    ]).listen((device) {
      if (device.name == 'Echo RVMS') {
        bleManager.connectToDevice(
          id: device.id,
          servicesWithCharacteristicsToDiscover: {
            Uuid.parse('6e400001-b5a3-f393-e0a9-e50e24dcca9e'): [
              Uuid.parse('6e400003-b5a3-f393-e0a9-e50e24dcca9e')
            ]
          },
        );

        deviceId = device.id;
      }

      final characteristic = QualifiedCharacteristic(
          serviceId: Uuid.parse('6e400001-b5a3-f393-e0a9-e50e24dcca9e'),
          characteristicId: Uuid.parse('6e400003-b5a3-f393-e0a9-e50e24dcca9e'),
          deviceId: deviceId);

      bleManager.subscribeToCharacteristic(characteristic).listen((data) {
        print(String.fromCharCodes(data));
        setState(() {
          messages.add(String.fromCharCodes(data));
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    messageStream?.close();
    messageStream = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('BLE Data')),
        body: Center(
            child: ListView.builder(
          itemBuilder: (ctx, idx) {
            return _makeElement(idx);
          },
          itemCount: messages.length,
        )));
  }

  Widget _makeElement(int index) {
    return Text(messages[index]);
  }
}
