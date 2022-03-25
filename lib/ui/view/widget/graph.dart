import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:tracer/models/data_packet.dart';

class GraphWidget extends StatelessWidget {
  const GraphWidget({Key? key}) : super(key: key);

  List<charts.Series<DataPacket, DateTime>> _createSampleData() {
    return [
      charts.Series<DataPacket, DateTime>(
        id: 'line',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (DataPacket packet, _) => packet.timestamp,
        measureFn: (DataPacket packet, _) => packet.value.toDouble(),
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
