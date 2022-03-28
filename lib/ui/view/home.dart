import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/datapacket.dart';
import '../../services/currentuser.dart';
import '../../services/datastore.dart';
import '../../ui/widgets/drawer.dart';

class HomePage extends StatelessWidget {
  final bool isConnected = true;
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final datastore = context.watch<DataStore>();
    final currentUser = context.watch<CurrentUser>();
    var greetingWidget = Text('HELLO, ${currentUser.user?.name ?? "NAME"}!',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30));

    var currentVitalsWidget = const Text('Current Vitals',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30));

    return Scaffold(
        appBar: AppBar(
          title: const Text('RVMS'),
          centerTitle: true,
        ),
        drawer: Components.drawer(context),
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
                content: Text('Stats are for nerds'),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              )
              );
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
                          child: Icon(Icons.battery_full, color: Colors.green)),
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
                  SizedBox(
                      height: 150,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 6,
                        separatorBuilder: (context, _) =>
                            const SizedBox(width: 10),
                        itemBuilder: (context, index) => buildItem(context, index, datastore),
                      )),
                ])
          ],
        ));
  }

  Widget buildItem(BuildContext context, int index, DataStore datastore) {
    var items = [
      buildCard('Heartrate', '${datastore.downloadedCache[VitalsType.ppg]?.last.value.toString()}BPM', const Icon(Icons.favorite)),
      buildCard('Temperature', '${datastore.downloadedCache[VitalsType.skinTemperature1]?.last.value.toString()}°C' , const Icon(Icons.whatshot)),
      buildCard('SPO2', '${datastore.downloadedCache[VitalsType.skinTemperature2]?.last.value.toString()}%', const Icon(Icons.bloodtype)),
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
      Text(name),
      icon,
      Text(value),
    ]);
  }
}
