import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../services/auth.dart';
import '../../services/ble.dart';
import '../widgets/app_drawer.dart';
import '../../models/data_packet.dart';

class HomePage extends StatelessWidget {
  final bool isConnected = false;
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser =
        context.select<AuthService, User?>((service) => service.user);
    if (currentUser == null) {
      context.go('login');
    }

    final deviceConnectionState =
        context.select<BleService, DeviceConnectionState>(
            (service) => service.deviceState);

    final greetingWidget = Text('HELLO, ${currentUser!.name}!',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30));

    var currentVitalsWidget = const Text('Current Vitals',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30));

    var connectionStatusWidget = GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text('Debug Info'),
                  content: const Text('Stats are for nerds'),
                  actions: <Widget>[
                    IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                ));
      },
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Connected', style: TextStyle(fontSize: 20)),
                  Text('LastSync: 12:00AM', style: TextStyle(fontSize: 15)),
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

    return Scaffold(
        appBar: AppBar(
          title: const Text('RVMS'),
          centerTitle: true,
        ),
        drawer: const AppDrawer(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            greetingWidget,
            const Divider(),
            //InkWell(
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: const Text('Debug Info'),
                          content: const Text('Stats are for nerds'),
                          actions: <Widget>[
                            IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  Navigator.pop(context);
                                })
                          ],
                        ));
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Connected', style: TextStyle(fontSize: 20)),
                          Text('LastSync: 12:00AM',
                              style: TextStyle(fontSize: 15)),
                        ]),
                    const Text.rich(TextSpan(
                      style: TextStyle(color: Colors.green, fontSize: 20),
                      children: <InlineSpan>[
                        TextSpan(
                            text: '93%',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        WidgetSpan(
                            child:
                                Icon(Icons.battery_full, color: Colors.green)),
                      ],
                    ))
                  ]),
            ),
            const Divider(),
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  currentVitalsWidget,
                  const Divider(),
                  connectionStatusWidget,
                  SizedBox(
                      height: 150,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 2,
                        separatorBuilder: (context, _) =>
                            const SizedBox(width: 10),
                        itemBuilder: (context, index) =>
                            buildItem(context, index),
                      )),
                ])
          ],
        ));
  }

  Widget buildItem(BuildContext context, int index) {
    var items = [
      // buildCard(
      //     'Heartrate',
      //     '${datastore.downloadedCache[VitalsType.ppg]?.last.value.toString()}BPM',
      //     const Icon(Icons.favorite)),
      // buildCard(
      //     'Temperature',
      //     '${datastore.downloadedCache[VitalsType.skinTemperature1]?.last.value.toString()}°C',
      //     const Icon(Icons.whatshot)),
      // buildCard(
      //     'SPO2',
      //     '${datastore.downloadedCache[VitalsType.skinTemperature2]?.last.value.toString()}%',
      //     const Icon(Icons.bloodtype)),
      buildCard('Sample', 'Sample_Value', const Icon(Icons.adb)),
      buildCard('Sample', 'Sample_Value', const Icon(Icons.adb)),
      buildCard('Sample', 'Sample_Value', const Icon(Icons.adb)),
    ];

    final vitalType = VitalsType.values[index];

    return Container(
        width: 120,
        height: 50,
        decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: InkWell(
          onTap: () {
            context.push('/graph', extra: vitalType);
          },
          child: items[index],
        ));
  }

  Widget buildCard(String name, String value, Icon icon) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Text(
        name,
        textAlign: TextAlign.center,
      ),
      icon,
      Text(value),
    ]);
  }
}
