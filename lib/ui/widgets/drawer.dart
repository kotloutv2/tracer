import 'package:flutter/material.dart';

import '../../models/datapacket.dart';

class Components {
  static Widget drawer(BuildContext context) {
    final drawer = Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          child: Text('Home Drawer'),
        ),
        ListTile(
          title: Text('Sync'),
        ),
        onClickHandler(context, '/graph', ListTile(
          title: Text('Heartrate'),
        ), VitalsType.ppg),
        onClickHandler(context, '/graph', ListTile(
          title: Text('SpO2'),
        ), VitalsType.skinTemperature1),
        onClickHandler(context, '/graph', ListTile(
          title: Text('Temperature'),
        ), VitalsType.skinTemperature2),
        ListTile(
          title: Text('Device Info'),
        ),
        ListTile(
          title: Text('Log Out'),
        )
      ],
    ));
    return drawer;
  }

  static Widget onClickHandler(context, String route, Widget child, Object? extras) {
    return GestureDetector(
    onTap: () {
      if(extras != null) {
        context.push(route, extras);
      } else {
        context.push(route);
      }
    },
    child: child,
    );
  }
}
