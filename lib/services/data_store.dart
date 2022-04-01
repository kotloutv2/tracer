import 'package:flutter/widgets.dart';

import '../models/data_packet.dart';
import '../models/user.dart';
import 'api.dart';

class Datastore extends ChangeNotifier {
  late Map<String, DataCollection> _dataCache;

  DateTime lastUpdateTime = DateTime.now();

  Datastore() {
    _dataCache = {};
  }

  void startListening(Stream<List<int>>? bleStream, User user) {
    bleStream!.listen((data) {
      final stringified = String.fromCharCodes(data);
      final split = stringified.split(' ');

      final ppg = int.parse(split[0], radix: 16);
      final temp1 = int.parse(split[1], radix: 16);
      final temp2 = int.parse(split[2], radix: 16);

      insertData(user, VitalsType.ppg, ppg.toDouble());
      insertData(user, VitalsType.skinTemperature1, temp1.toDouble() / 100.0);
      insertData(user, VitalsType.skinTemperature2, temp2.toDouble() / 100.0);
    });
  }

  void insertData(User user, VitalsType type, double value) {
    _dataCache
        .putIfAbsent(user.email, () => DataCollection())
        .addData(type, DataPacket(DateTime.now(), value));
  }

  void fetchData(User user) async {
    await Api.getVitals(user.email).then((data) {
      _dataCache
          .putIfAbsent(user.email, () => DataCollection())
          .insertFromJson(data);
    });
  }

  List<DataPacket> getBodyTemperatures(User user) {
    if (_dataCache[user.email] == null) {
      return [];
    }
    return _dataCache[user.email]!.temp1Data;
  }

  double getLatestAmbientTemperature(User user) {
    var sortedTempData = _dataCache[user.email]!.temp2Data..sort();
    return sortedTempData.last.value;
  }
}
