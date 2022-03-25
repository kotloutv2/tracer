enum VitalsType { ppg, skinTemperature1, skinTemperature2 }

class DataPacket {
  final DateTime timestamp;
  final double value;
  final VitalsType type;

  const DataPacket(this.timestamp, this.value, this.type);
}
