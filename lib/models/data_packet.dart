enum VitalsType { ppg, skinTemperature1, skinTemperature2 }

class DataPacket implements Comparable<DataPacket> {
  final DateTime timestamp;
  final double value;

  const DataPacket(this.timestamp, this.value);

  factory DataPacket.fromJson(dynamic json) {
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
  final Set<DataPacket> _ppgLocalData = {};
  final Set<DataPacket> _temp1LocalData = {};
  final Set<DataPacket> _temp2LocalData = {};

  final Set<DataPacket> _ppgCloudData = {};
  final Set<DataPacket> _temp1CloudData = {};
  final Set<DataPacket> _temp2CloudData = {};

  Set<DataPacket> get ppgData => _ppgCloudData.union(_ppgLocalData);
  Set<DataPacket> get temp1Data => _temp1CloudData.union(_temp1LocalData);
  Set<DataPacket> get temp2Data => _temp2CloudData.union(_temp2LocalData);

  /// Convert only locally stored data to JSON
  Map<String, List<DataPacket>> toJson() {
    return {
      'ppg': _ppgLocalData.toList(),
      'skinTemperature1': _temp1LocalData.toList(),
      'skinTemperature2': _temp2LocalData.toList(),
    };
  }

  /// Insert all data in JSON into list
  void insertFromJson(Map<String, dynamic> json) {
    if (json.containsKey('ppg')) {
      List<dynamic> dataList = json['ppg'];
      _ppgCloudData.addAll(dataList.map(DataPacket.fromJson));
    }

    if (json.containsKey('skinTemperature1')) {
      List<dynamic> dataList = json['skinTemperature1'];
      _temp1CloudData.addAll(dataList.map(DataPacket.fromJson));
    }

    if (json.containsKey('skinTemperature2')) {
      List<dynamic> dataList = json['skinTemperature2'];
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
