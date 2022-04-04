import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../services/ble.dart';

class RvmsStatus extends StatelessWidget {
  const RvmsStatus({
    Key? key,
  }) : super(key: key);

  Text generateConnectionText(DeviceConnectionState state) {
    switch (state) {
      case DeviceConnectionState.connected:
        return const Text('Connected', style: TextStyle(fontSize: 20));
      case DeviceConnectionState.connecting:
        return const Text('Connecting...', style: TextStyle(fontSize: 20));
      case DeviceConnectionState.disconnected:
        return const Text('Disconnected', style: TextStyle(fontSize: 20));
      case DeviceConnectionState.disconnecting:
        return const Text('Disconnecting...', style: TextStyle(fontSize: 20));
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceConnectionState =
        context.select<BleService, DeviceConnectionState>(
            (service) => service.deviceState);

    return GestureDetector(
      onTap: () {
        context.push('/bluetooth');
      },
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              generateConnectionText(deviceConnectionState),
              const Text('Last Sync at: 12:00AM',
                  style: TextStyle(fontSize: 15)),
            ]),
            const Text.rich(TextSpan(
              style: TextStyle(color: Colors.green, fontSize: 20),
              children: <InlineSpan>[
                TextSpan(
                    text: '93%', style: TextStyle(fontWeight: FontWeight.bold)),
                WidgetSpan(
                    child: Icon(Icons.battery_full, color: Colors.green)),
              ],
            ))
          ]),
    );
  }
}
