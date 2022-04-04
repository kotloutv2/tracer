import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:tracer/services/api.dart';

import '../../models/user.dart';
import '../../services/auth.dart';
import '../../services/ble.dart';
import '../widgets/app_drawer.dart';

class Greeter extends StatelessWidget {
  const Greeter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser =
        context.select<AuthService, User?>((service) => service.user);
    var greeterText = 'Hello';
    if (currentUser != null) {
      greeterText = 'Hello, ${currentUser.name}';
    }
    return Text(greeterText,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30));
  }
}

class ConnectionStatus extends StatelessWidget {
  const ConnectionStatus({
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

class VitalsCards extends StatelessWidget {
  final String location;
  final String title;
  final Icon icon;
  final String value;

  const VitalsCards(
      {Key? key,
      required this.title,
      required this.location,
      required this.icon,
      required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(location);
      },
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Text(
          title,
          textAlign: TextAlign.center,
        ),
        icon,
        Text(value),
      ]),
    );
  }
}

class MobileHomePage extends StatelessWidget {
  final bool isConnected = false;

  const MobileHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var vitalsCards = [
      const VitalsCards(
          title: 'PPG',
          value: '',
          icon: Icon(Icons.favorite),
          location: '/graph/ppg'),
      const VitalsCards(
          title: 'Skin Temperature',
          value: '27°C',
          icon: Icon(Icons.thermostat),
          location: '/graph/skinTemperature1'),
      const VitalsCards(
          title: 'Ambient Temperature',
          value: '37°C',
          icon: Icon(Icons.thermostat),
          location: '/graph/skinTemperature2'),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        const Greeter(),
        const Divider(),
        const ConnectionStatus(),
        Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Current Vitals',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
              const Divider(),
              SizedBox(
                  height: 150,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: vitalsCards.length,
                    separatorBuilder: (context, _) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      return Container(
                          width: 120,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          child: vitalsCards[index]);
                    },
                  )),
            ])
      ],
    );
  }
}

class PatientListEntry extends StatelessWidget {
  final User user;
  const PatientListEntry({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push('/vitals/${user.email}');
      },
      child: Text(
        user.name,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class PatientList extends StatelessWidget {
  const PatientList({Key? key}) : super(key: key);

  Future<List<User>> _getPatientList(String email) async {
    return await Api.getPatients(email);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser =
        context.select<AuthService, User?>((service) => service.user);

    return Row(
      children: [
        FutureBuilder<List<User>>(
          future: _getPatientList(currentUser!.email),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Text('No Patients Registered');
              } else {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length,
                  itemBuilder: ((context, index) => PatientListEntry(
                        user: snapshot.data![index],
                      )),
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ],
    );
  }
}

class WebHomePage extends StatelessWidget {
  const WebHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const <Widget>[
        Greeter(),
        Divider(),
        PatientList(),
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  final bool isConnected = false;
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser =
        context.select<AuthService, User?>((service) => service.user);
    if (currentUser == null) {
      context.goNamed('login');
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('RVMS'),
          centerTitle: true,
        ),
        drawer: const AppDrawer(),
        body: kIsWeb ? const WebHomePage() : const MobileHomePage());
  }
}
