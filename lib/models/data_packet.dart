import 'dart:convert';

enum VitalsType { ppg, skinTemperature1, skinTemperature2 }

class DataPacket implements Comparable<DataPacket> {
  final DateTime timestamp;
  final double value;

  const DataPacket(this.timestamp, this.value);

  factory DataPacket.fromJson(Map<String, dynamic> json) {
    String timestampString = json['timestamp'];

    return DataPacket(
        DateTime.parse(timestampString), json['value'].toDouble());
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['timestamp'] = timestamp.toIso8601String();
    data['value'] = value;

    return data;
  }

  @override
  int compareTo(DataPacket other) {
    return timestamp.compareTo(other.timestamp);
  }
}

class DataCollection {
  final List<DataPacket> _ppgLocalData = [];
  final List<DataPacket> _temp1LocalData = [];
  final List<DataPacket> _temp2LocalData = [];

  final List<DataPacket> _ppgCloudData = [];
  final List<DataPacket> _temp1CloudData = [];
  final List<DataPacket> _temp2CloudData = [];

  List<DataPacket> get ppgData => _ppgCloudData + _ppgLocalData;
  List<DataPacket> get temp1Data => _temp1CloudData + _temp2LocalData;
  List<DataPacket> get temp2Data => _temp1CloudData + _temp2LocalData;

  /// Convert only locally stored data to JSON
  Map<String, List<DataPacket>> toJson() {
    return {
      'ppg': _ppgLocalData,
      'skinTemperature1': _temp1LocalData,
      'skinTemperature2': _temp2LocalData,
    };
  }

  /// Insert all data in JSON into list
  void insertFromJson(Map<String, dynamic> json) {
    if (json.containsKey('ppg')) {
      List<Map<String, dynamic>> dataList = json['ppg'];
      _ppgCloudData.addAll(dataList.map(DataPacket.fromJson));
    }

    if (json.containsKey('skinTemperature1')) {
      List<Map<String, dynamic>> dataList = json['skinTemperature1'];
      _temp1CloudData.addAll(dataList.map(DataPacket.fromJson));
    }

    if (json.containsKey('skinTemperature2')) {
      List<Map<String, dynamic>> dataList = json['skinTemperature2'];

      _temp2CloudData.addAll(dataList.map(DataPacket.fromJson));
    }
  }

  void addData(VitalsType type, DataPacket packet) {
    switch (type) {
      case VitalsType.ppg:
        _ppgLocalData.add(packet);
        break;
      case VitalsType.skinTemperature1:
        _temp1LocalData.add(packet);
        break;
      case VitalsType.skinTemperature2:
        _temp2LocalData.add(packet);
        break;
    }
  }
}
