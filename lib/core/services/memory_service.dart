// coverage:ignore-file

import 'package:flutter/services.dart';

import '../constants/method_channel_constants.dart';

class MemoryInfoService {
  static const MethodChannel _channel = MethodChannel(MethodChannelConstants.configChannel);

  /// Returns the total memory in MB of the device.
  static Future<int> getTotalMemoryMB() async {
    final int memoryMB = await _channel.invokeMethod(MethodChannelConstants.getTotalMemoryMethod);
    return memoryMB;
  }
}