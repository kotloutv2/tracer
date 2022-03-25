import 'package:flutter/foundation.dart';

import '../models/datapacket.dart';

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
