import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';
import 'package:tracer/models/datapacket.dart';

import '../../services/datastore.dart';
import '../../ui/widgets/drawer.dart';

class GraphPage extends StatelessWidget {
  final bool isConnected = true;
  const GraphPage({Key? key, this.vitalsType}) : super(key: key);
  final VitalsType? vitalsType;

  List<charts.Series<Pair, DateTime>> _createBarChart(data) {
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

  List<charts.Series<Pair, String>> _createSampleDataBar(data) {
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
    final datastore = context.watch<DataStore>();
    var data = datastore.downloadedCache[vitalsType];
    final points = data?.map((e) => Pair(e.timestamp, e.value)).toList() ?? [];
    switch (vitalsType) {
      case VitalsType.ppg:
        // TODO: Handle this case.
        break;
      case VitalsType.skinTemperature1:
        // TODO: Handle this case.
        break;
      case VitalsType.skinTemperature2:
        // TODO: Handle this case.
        break;
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('Graph View'),
          centerTitle: true,
        ),
        drawer: Components.drawer(context),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
                height: 300,
                /* child: new charts.BarChart( */
                /*   _createSampleDataBar(), */
                /* )), */
                child: charts.TimeSeriesChart(
                  _createBarChart(points),
                )),
            Expanded(
                child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemCount: data?.length ?? 0,
                    separatorBuilder: (context, _) =>
                        const SizedBox(height: 10),
                    itemBuilder: (content, index) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(data![index].timestamp.toString()),
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
