import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  final bool isConnected = true;
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var greetingWidget = const Text('HELLO, {NAME}!',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30));

    var currentVitalsWidget = const Text('Current Vitals',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30));

    return Scaffold(
        appBar: AppBar(
          title: const Text('RVMS'),
          centerTitle: true,
        ),
        drawer: Drawer(
            child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              child: Text('Home Drawer'),
            ),
            ListTile(
              title: Text('Sync'),
            ),
            ListTile(
              title: Text('Heartrate'),
            ),
            ListTile(
              title: Text('SpO2'),
            ),
            ListTile(
              title: Text('Temperature'),
            ),
            ListTile(
              title: Text('Device Info'),
            ),
            ListTile(
              title: Text('Log Out'),
            )
          ],
        )),
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
                  SizedBox(
                      height: 150,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: 6,
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
      buildCard('Heartrate', '98BPM', const Icon(Icons.favorite)),
      buildCard('Temperature', '22.5°C', const Icon(Icons.whatshot)),
      buildCard('SPO2', '60%', const Icon(Icons.bloodtype)),
      buildCard('Sample', 'Sample_Value', const Icon(Icons.adb)),
      buildCard('Sample', 'Sample_Value', const Icon(Icons.adb)),
      buildCard('Sample', 'Sample_Value', const Icon(Icons.adb)),
    ];
    return Container(
        width: 120,
        height: 50,
        decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: InkWell(
          onTap: () {
            context.push('/graph');
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
