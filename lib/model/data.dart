import 'package:flutter/foundation.dart';

enum VitalsType { ppg, skinTemperature1, skinTemperature2 }

class DataPacket {
  final DateTime timestamp;
  final double value;
  final VitalsType type;

  const DataPacket(this.timestamp, this.value, this.type);
}

class DataStore extends ChangeNotifier {
  final List<DataPacket> _notUploadedCache = [];

  final Map<VitalsType, List<DataPacket>> _downloadedCache =
      <VitalsType, List<DataPacket>>{};

  DateTime lastUpdateTime = DateTime.now();

  DataStore() {}

  void insertDatapoints(List<DataPacket> packets) {
    _notUploadedCache.addAll(packets);
  }
}
