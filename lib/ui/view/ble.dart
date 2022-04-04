import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import 'package:tracer/services/auth.dart';
import 'package:tracer/services/ble.dart';

import '../../services/data_store.dart';

class BleConnectScreen extends StatefulWidget {
  const BleConnectScreen({Key? key}) : super(key: key);

  @override
  State<BleConnectScreen> createState() => _BleConnectScreenState();
}

// class BleDevice {
//   String id;
//   String name;

//   BleDevice(this.id, this.name);
// }

class _BleConnectScreenState extends State<BleConnectScreen> {
  bool scanStarted = false;

  @override
  Widget build(BuildContext context) {
    final bleService = context.watch<BleService>();
    final bleDevices = bleService.scanResults;

    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  if (!scanStarted) {
                    bleService.startScan();
                  } else {
                    bleService.stopScan();
                  }
                  setState(() {
                    scanStarted = !scanStarted;
                  });
                },
                icon: scanStarted
                    ? const Icon(Icons.sync_disabled)
                    : const Icon(Icons.sync))
          ],
        ),
        body: Column(children: [
          Expanded(
              child: ListView.builder(
                  itemCount: bleDevices.length,
                  itemBuilder: ((context, index) {
                    final key = bleDevices.keys.elementAt(index);
                    return DeviceButton.fromDiscoveredDevice(bleDevices[key]!);
                  }))),
        ]));
  }
}

class DeviceButton extends StatelessWidget {
  final DiscoveredDevice discoveredDevice;

  const DeviceButton.fromDiscoveredDevice(this.discoveredDevice, {Key? key})
      : super(key: key);

  Icon getIcon(BleService bleService) {
    if (bleService.connectedDevice != null &&
        discoveredDevice.id == bleService.connectedDevice) {
      return const Icon(Icons.bluetooth_connected);
    }

    return const Icon(Icons.bluetooth);
  }

  @override
  Widget build(BuildContext context) {
    final bleService = context.watch<BleService>();
    final datastore = context.watch<Datastore>();
    final currentUser = context.read<AuthService>().user!;

    final isEnabled =
        (bleService.deviceState != DeviceConnectionState.connecting) ||
            (bleService.deviceState != DeviceConnectionState.disconnecting);

    return Card(
        child: ListTile(
      onTap: () async {
        if (bleService.connectedDevice != null) {
          if (bleService.connectedDevice != discoveredDevice.id) {
            bleService.disconnect();
            await bleService.connect(discoveredDevice);
            datastore.startListening(bleService.dataStream, currentUser);
          }
        } else {
          await bleService.connect(discoveredDevice);
          datastore.startListening(bleService.dataStream, currentUser);
        }
      },
      enabled: isEnabled,
      leading: getIcon(bleService),
      title: Text(discoveredDevice.name),
      subtitle: Text(discoveredDevice.id),
      trailing: const Icon(Icons.more_vert),
    ));
  }
}
