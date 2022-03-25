enum VitalsType { ppg, skinTemperature1, skinTemperature2 }

class DataPacket {
  final DateTime timestamp;
  final double value;
  final VitalsType type;

  const DataPacket(this.timestamp, this.value, this.type);

  factory DataPacket.fromJson(Map<String, dynamic> json, VitalsType type) {
    String timestampString = json['timestamp'];

    return DataPacket(
        DateTime.parse(timestampString), json['value'].toDouble(), type);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['timestamp'] = timestamp.toIso8601String();
    data['value'] = value;

    return data;
  }
}
