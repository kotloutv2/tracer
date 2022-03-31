import 'package:tracer/models/data_packet.dart';
import 'package:tracer/models/user.dart';
import 'package:tracer/services/api.dart';

class Datastore {
  late Map<String, DataCollection> _dataCache;

  DateTime lastUpdateTime = DateTime.now();

  Datastore() {
    _dataCache = {};
  }

  void insertDatapoints(VitalsType type, List<DataPacket> packets) {
    _dataCache.forEach((_, value) {
      for (final packet in packets) {
        value.addData(type, packet);
      }
    });
  }

  void fetchData(User user) async {
    await Api.getVitals(user.email).then((data) {
      _dataCache
          .putIfAbsent(user.email, () => DataCollection())
          .insertFromJson(data);
    });
  }

  List<DataPacket> getBodyTemperatures(User user) {
    return _dataCache[user.email]!.temp1Data;
  }

  double getLatestAmbientTemperature(User user) {
    var sortedTempData = _dataCache[user.email]!.temp2Data..sort();
    return sortedTempData.last.value;
  }
}
