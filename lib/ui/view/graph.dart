import 'dart:async';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracer/services/auth.dart';

import '../../models/data_packet.dart';
import '../../services/data_store.dart';
import '../../ui/widgets/app_drawer.dart';
import '../../models/user.dart';

class GraphPage extends StatefulWidget {
  // final VitalsType vitalsType;
  const GraphPage({Key? key}) : super(key: key);

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 5), (Timer t) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    var currentUser =
        context.select<AuthService, User?>((service) => service.user);
    final datastore = context.watch<Datastore>();

    var data = datastore.getBodyTemperatures(currentUser!);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Graph View'),
          centerTitle: true,
        ),
        drawer: const AppDrawer(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
                height: 300,
                child: charts.TimeSeriesChart(
                  [
                    charts.Series<DataPacket, DateTime>(
                      id: 'line',
                      colorFn: (_, __) =>
                          charts.MaterialPalette.blue.shadeDefault,
                      domainFn: (DataPacket packet, _) => packet.timestamp,
                      measureFn: (DataPacket packet, _) => packet.value,
                      data: data,
                    )
                  ],
                  animate: true,
                  primaryMeasureAxis: const charts.NumericAxisSpec(
                      tickProviderSpec: charts.BasicNumericTickProviderSpec(
                          dataIsInWholeNumbers: false, zeroBound: false)),
                )),
            Expanded(
                child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemCount: data.length,
                    separatorBuilder: (context, _) =>
                        const SizedBox(height: 10),
                    itemBuilder: (content, index) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(data[index].timestamp.toString()),
                              Text('${data[index].value}'),
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
