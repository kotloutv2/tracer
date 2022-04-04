import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/data_packet.dart';
import '../../models/user.dart';
import '../../services/api.dart';
import '../../services/data_store.dart';

class UserVitals extends StatelessWidget {
  final String email;
  const UserVitals({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final datastore = context.read<Datastore>();

    final thisUser =
        Api.getUser(email, UserRole.patient).then((User user) async {
      await datastore.fetchData(user);
      return user;
    });

    return FutureBuilder<User>(
        future: thisUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data!;
            return Column(children: [
              GraphWidget(data: datastore.getPpg(user)),
              GraphWidget(data: datastore.getBodyTemperatures(user)),
              GraphWidget(data: datastore.getAmbientTemperatures(user)),
            ]);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

class GraphWidget extends StatelessWidget {
  final List<DataPacket> data;
  const GraphWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 300,
        child: charts.TimeSeriesChart(
          [
            charts.Series<DataPacket, DateTime>(
              id: 'line',
              colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
              domainFn: (DataPacket packet, _) => packet.timestamp,
              measureFn: (DataPacket packet, _) => packet.value,
              data: data,
            )
          ],
          animate: true,
          domainAxis: const charts.DateTimeAxisSpec(
              renderSpec: charts.SmallTickRendererSpec(
                  labelStyle: charts.TextStyleSpec(
                      color: charts.Color(r: 211, g: 95, b: 95)))),
          primaryMeasureAxis: const charts.NumericAxisSpec(
              renderSpec: charts.SmallTickRendererSpec(
                  labelStyle: charts.TextStyleSpec(
                      color: charts.Color(r: 211, g: 95, b: 95))),
              tickProviderSpec: charts.BasicNumericTickProviderSpec(
                  dataIsInWholeNumbers: false, zeroBound: false)),
        ));
  }
}
