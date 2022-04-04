import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  Widget onClickHandler(context, String route, Widget child) {
    return GestureDetector(
      onTap: () {
        context.push(route);
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          child: Text('Home Drawer'),
        ),
        const ListTile(
          title: Text('Sync'),
        ),
        // onClickHandler(
        //     context,
        //     '/graph',
        const ListTile(
          title: Text('Heartrate'),
        ),
        // VitalsType.ppg),
        onClickHandler(
            context,
            'temp1Graph',
            const ListTile(
              title: Text('Skin Temperature'),
            )),
        // onClickHandler(
        // context,
        // '/graph',
        const ListTile(
          title: Text('Temperature'),
        ),
        // VitalsType.skinTemperature2),
        const ListTile(
          title: Text('Device Info'),
        ),
        GestureDetector(
          onTap: () {
            final authService = context.read<AuthService>();

            authService.logOut();
          },
          child: const ListTile(
            title: Text('Log Out'),
          ),
        )
      ],
    ));
  }
}
