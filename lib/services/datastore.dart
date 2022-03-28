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
  }

  Map<VitalsType, List<DataPacket>> get downloadedCache => _downloadedCache;

  void insertDatapoints(List<DataPacket> packets) {
    _notUploadedCache.addAll(packets);
  }

  Future<void> _getJson() async {
    final response =
        await rootBundle.loadString('assets/test_patient_data.json');
    final data = await jsonDecode(response);
    final user = User(email: data['Email'], name: data['Name']);
    final vitalMap = {
      'Ecg': VitalsType.ppg,
      'HeartRate': VitalsType.skinTemperature1,
      'Spo2': VitalsType.skinTemperature2
    };
    for (MapEntry entry in data['Vitals'].entries) {
      final vitalType = vitalMap[entry.key];
      for (var datum in entry.value) {
        if (vitalType == null) {
          // Error, invalid vital type, skip data point
          break;
        }
        final packet = DataPacket(
            DateTime.parse(datum['timestamp']), datum['value'], vitalType);
        if (_downloadedCache.containsKey(vitalType)) {
          _downloadedCache[vitalType]?.add(packet);
        } else {
          _downloadedCache.putIfAbsent(vitalType, () => [packet]);
        }
      }
    }
    lastUpdateTime = DateTime.now();
    notifyListeners();
    print('Populated: $_downloadedCache at $lastUpdateTime');
  }

}
