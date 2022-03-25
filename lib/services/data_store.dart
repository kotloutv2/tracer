import 'package:flutter/foundation.dart';
import 'dart:math';

import '../models/data_packet.dart';

class DataStore extends ChangeNotifier {
  final List<DataPacket> _notUploadedCache = [];

  final List<DataPacket> _downloadedCache = [];

  DateTime lastUpdateTime = DateTime.now();

  DataStore() {}

  void insertDatapoints(List<DataPacket> packets) {
    _notUploadedCache.addAll(packets);
  }

  double _randomTempValue() {
    var random = Random();

    const minVal = 36.0;
    const maxVal = 37.5;

    return random.nextDouble() * (maxVal - minVal) + minVal;
  }

  // double _randomPpgValue() {
  //   var random = Random();

  //   const minVal = 8000;
  //   const maxVal = 5000;

  //   return random.nextDouble() * (maxVal - minVal) + minVal;
  // }

  void insertFakeData() {}
}
