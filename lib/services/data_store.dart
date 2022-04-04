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

      insertData(user.email, VitalsType.ppg, ppg.toDouble());
      insertData(
          user.email, VitalsType.skinTemperature1, temp1.toDouble() / 100.0);
      insertData(
          user.email, VitalsType.skinTemperature2, temp2.toDouble() / 100.0);
    });
  }

  void insertData(String email, VitalsType type, double value) {
    _dataCache
        .putIfAbsent(email, () => DataCollection())
        .addData(type, DataPacket(DateTime.now(), value));
  }

  Future<void> fetchData(User user) async {
    await Api.getVitals(user.email).then((data) {
      _dataCache
          .putIfAbsent(user.email, () => DataCollection())
          .insertFromJson(data);
    });
  }

  Future<void> pushData(User user) async {
    if (_dataCache[user.email] != null) {
      await Api.putVitals(user.email, _dataCache[user.email]!);
    }
  }

  List<DataPacket> getBodyTemperatures(User user) {
    if (_dataCache[user.email] == null) {
      return [];
    }
    return _dataCache[user.email]!.temp1Data.toList();
  }

  List<DataPacket> getAmbientTemperatures(User user) {
    if (_dataCache[user.email] == null) {
      return [];
    }
    return _dataCache[user.email]!.temp2Data.toList();
  }

  List<DataPacket> getPpg(User user) {
    if (_dataCache[user.email] == null) {
      return [];
    }
    return _dataCache[user.email]!.ppgData.toList();
  }
}
