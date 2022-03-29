import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../../services/ble.dart';
import '../../services/locator.dart';

class BleViewModel extends ChangeNotifier {
  final _bleService = locator<BleService>();
  DiscoveredDevice? device;
  // Model related functions
  BleViewModel() {}

  // View related functions

}
