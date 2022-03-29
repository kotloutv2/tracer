import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          child: Text('Home Drawer'),
        ),
        // ListTile(
        //   title: Text('Sync'),
        // ),
        // ListTile(
        //   title: Text('Heartrate'),
        // ),
        // ListTile(
        //   title: Text('SpO2'),
        // ),
        ListTile(
          title: Text('Temperature'),
        ),
        ListTile(
          title: Text('Device Info'),
          onTap: () {
            context.go('deviceinfo');
          },
        ),
        // ListTile(
        //   title: Text('Log Out'),
        // )
      ],
    ));
  }
}
