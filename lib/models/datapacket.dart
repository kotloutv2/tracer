enum VitalsType { ppg, skinTemperature1, skinTemperature2 }

class DataPacket {
  final DateTime timestamp;
  final double value;
  final VitalsType type;

  const DataPacket(this.timestamp, this.value, this.type);
}

extension VitalsTypeExtension on VitalsType {
  static VitalsType? parseVitalsType(String vitalStr) {
    final vitalMap = {
      'Ecg': VitalsType.ppg,
      'HeartRate': VitalsType.skinTemperature1,
      'Spo2': VitalsType.skinTemperature2
    };
    return vitalMap[vitalStr];
  }

  String? getVitalName() {
    final vitalMap = {
      VitalsType.ppg: 'Ecg',
      VitalsType.skinTemperature1: 'HeartRate',
      VitalsType.skinTemperature2: 'Spo2',
    };
    return vitalMap[this];
  }
}
