import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class GraphPage extends StatelessWidget {
  final bool isConnected = true;
  const GraphPage({Key? key}) : super(key: key);

  List<charts.Series<Pair, DateTime>> _createSampleData() {
    final data = [
      Pair(DateTime(2017, 9, 19), 5),
      Pair(DateTime(2017, 9, 26), 25),
      Pair(DateTime(2017, 10, 3), 100),
      Pair(DateTime(2017, 10, 10), 75),
    ];

    return [
      charts.Series<Pair, DateTime>(
        id: 'line',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Pair pair, _) => pair.x,
        measureFn: (Pair pair, _) => pair.y,
        data: data,
      )
    ];
  }

  List<charts.Series<Pair, String>> _createSampleDataBar() {
    final data = [
      Pair(DateTime(2017, 9, 19), 5),
      Pair(DateTime(2017, 9, 26), 25),
      Pair(DateTime(2017, 10, 3), 100),
      Pair(DateTime(2017, 10, 10), 75),
      Pair(DateTime(2017, 10, 11), 125),
    ];

    return [
      charts.Series(
        id: 'bar',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (Pair pair, _) => pair.x.toString(),
        measureFn: (Pair pair, _) => pair.y,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Graph View'),
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
            SizedBox(
                height: 300,
                /* child: new charts.BarChart( */
                /*   _createSampleDataBar(), */
                /* )), */
                child: charts.TimeSeriesChart(
                  _createSampleData(),
                )),
            Expanded(
                child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemCount: 30,
                    separatorBuilder: (context, _) =>
                        const SizedBox(height: 10),
                    itemBuilder: (content, index) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(DateTime.utc(2022, 2, index).toString()),
                              const Text('Data'),
                            ])))
          ],
        ));
  }
}

class Pair {
  final DateTime x;
  final double y;

  Pair(this.x, this.y);
}
