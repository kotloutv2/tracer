import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("RVMS"),
          centerTitle: true,
        ),
        drawer: Drawer(
            child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              child: Text("Drawer"),
            ),
            ListTile(
              title: Text("Sync"),
            ),
            ListTile(
              title: Text("Heartrate"),
            ),
            ListTile(
              title: Text("SpO2"),
            ),
            ListTile(
              title: Text("Temperature"),
            ),
            ListTile(
              title: Text("Device Info"),
            ),
            ListTile(
              title: Text("Log Out"),
            )
          ],
        )),
        body: const Text("Hi"));
  }
}
