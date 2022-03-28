import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import '../models/datapacket.dart';
import '../models/user.dart';

class DataStore extends ChangeNotifier {
  final List<DataPacket> _notUploadedCache = [];

  final Map<VitalsType, List<DataPacket>> _downloadedCache =
      <VitalsType, List<DataPacket>>{};

  DateTime lastUpdateTime = DateTime.now();

  DataStore() {
    _getJson();
    notifyListeners();
  }

  get downloadedCache => _downloadedCache;

  void insertDatapoints(List<DataPacket> packets) {
    _notUploadedCache.addAll(packets);
  }

Future<void> _getJson() async {
  final response =
      await rootBundle.loadString('assets/test_patient_data.json');
  final data = await jsonDecode(response);
  final user = User(email: data["Email"], name: data["Name"]);
  print(data["Vitals"]["Ecg"]);
  for (var datum in data["Vitals"]["Ecg"]) {
    final packet = DataPacket(DateTime.parse(datum["timestamp"]), datum["value"], VitalsType.ppg);
    if (_downloadedCache.containsKey(VitalsType.ppg)) {
      _downloadedCache[VitalsType.ppg]?.add(packet);
    } else {
      _downloadedCache.putIfAbsent(VitalsType.ppg, () => [packet]);
    }
  }
  lastUpdateTime = DateTime.now();
  print('Populated: ${_downloadedCache} at ${lastUpdateTime}');
}

}
