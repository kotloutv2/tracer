import 'package:flutter/foundation.dart';
import 'package:tracer/models/data_packet.dart';
import 'package:tracer/services/api.dart';
import 'package:tracer/services/current_user.dart';

class DataStore extends ChangeNotifier {
  final Map<VitalsType, List<DataPacket>> _notUploadedCache = {};
  final Map<VitalsType, List<DataPacket>> _downloadedCache = {};

  final DataCollection _dataCache = DataCollection();

  final CurrentUser _user;

  DateTime lastUpdateTime = DateTime.now();

  DataStore(this._user);

  void insertDatapoints(VitalsType type, List<DataPacket> packets) {
    _notUploadedCache[type]!.addAll(packets);
  }

  void fetchData() {
    var vitals = Api.getVitals(_user.user!.email);
  }
}
