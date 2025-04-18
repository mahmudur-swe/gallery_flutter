import 'dart:io';

import 'package:flutter/services.dart';

class Utils {
  static void exitApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0); // not recommended by Apple, but technically allowed
    }
  }
}
