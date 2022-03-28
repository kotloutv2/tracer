import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import 'package:tracer/services/ble.dart';

class BleConnectScreen extends StatefulWidget {
  const BleConnectScreen({Key? key}) : super(key: key);

  @override
  State<BleConnectScreen> createState() => _BleConnectScreenState();
}

class _BleConnectScreenState extends State<BleConnectScreen> {
  List<DiscoveredDevice> _devices = [];
  @override
  Widget build(BuildContext context) {
    final bleService = context.read<BleService>();

    final bleDeviceTiles = bleService.startScan();

    return Scaffold(
        body: Column(
      children: [
        StreamBuilder(
          stream: bleDeviceTiles,
          builder: (ctx, AsyncSnapshot<DiscoveredDevice?> snapshot) {
            _devices.add(snapshot.data!);
            return ListView.builder(itemBuilder: ((context, index) {
              return DeviceButton.fromRvmsDevice(_devices[index]);
            }));
          },
        )
      ],
    ));
  }
}

class DeviceButton extends StatelessWidget {
  DiscoveredDevice rvmsDevice;

  DeviceButton.fromRvmsDevice(this.rvmsDevice, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bleService = context.read<BleService>();
    final connectionStatus = context.watch<ConnectionStatus>();

    return ElevatedButton(
        onPressed: () {
          bleService.connect(rvmsDevice);
          if (connectionStatus == ConnectionStatus.connected ||
              connectionStatus == ConnectionStatus.connecting) {
            return;
          }
        },
        child: Text(rvmsDevice.id));
  }
}
