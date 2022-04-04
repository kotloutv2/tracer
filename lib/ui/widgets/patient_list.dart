import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../services/auth.dart';

class PatientListEntry extends StatelessWidget {
  final User user;
  const PatientListEntry({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 120,
        height: 50,
        child: Card(
          child: InkWell(
              onTap: () {
                context.push('/user', extra: user);
              },
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    user.name,
                    textAlign: TextAlign.center,
                  ))),
        ));
  }
}

class PatientList extends StatelessWidget {
  const PatientList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();

    return Flexible(
        fit: FlexFit.loose,
        child: SizedBox(
            height: 120,
            child: Row(
              children: [
                FutureBuilder<List<User>>(
                  future: authService.getPatientList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return const Text('No Patients Registered');
                      } else {
                        return Container(
                            margin: const EdgeInsets.all(16.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.length,
                              itemBuilder: ((context, index) =>
                                  PatientListEntry(
                                    user: snapshot.data![index],
                                  )),
                            ));
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ],
            )));
  }
}
