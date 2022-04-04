import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../models/user.dart';
import '../../services/auth.dart';
import '../widgets/app_drawer.dart';
import '../widgets/greeter.dart';
import '../widgets/patient_list.dart';
import '../widgets/vitals_card.dart';
import '../widgets/rvms_status.dart';

class MobileHomePage extends StatelessWidget {
  final bool isConnected = false;

  const MobileHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var vitalsCards = [
      const VitalsCard(
          title: 'PPG',
          value: '',
          icon: Icon(Icons.favorite),
          location: '/graph/ppg'),
      const VitalsCard(
          title: 'Skin Temperature',
          value: '27°C',
          icon: Icon(Icons.thermostat),
          location: '/graph/skinTemperature1'),
      const VitalsCard(
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
        const RvmsStatus(),
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

class WebHomePage extends StatelessWidget {
  WebHomePage({Key? key}) : super(key: key);

  final _newPatientInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        const Greeter(),
        const Divider(),
        TextButton(
          child: const Text('Add new Patients'),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    children: [
                      TextField(
                        decoration:
                            const InputDecoration(labelText: "Patient's email"),
                        controller: _newPatientInputController,
                        onSubmitted: (String patient) async {
                          await authService.addPatientToList(patient);
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                          onPressed: () async {
                            await authService.addPatientToList(
                                _newPatientInputController.text);
                            Navigator.pop(context);
                          },
                          child: const Text('Add User'))
                    ],
                  );
                });
          },
        ),
        const PatientList(),
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
        body: kIsWeb ? WebHomePage() : const MobileHomePage());
  }
}
