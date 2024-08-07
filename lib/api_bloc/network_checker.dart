import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkHelper {
  static Future<bool> isInternetIsOn({bool showToast = true}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    showNoInternetToast();
    return false;
  }

  static showNoInternetToast() {
    // BotToast.showText(
    //     text: allMessages.value.noInternetConnection ?? 'No Internet Connection',
    //     align: Alignment.topCenter,
    //     contentColor: Colors.red);
    SnackBar(
      content: const Text('No Internet Connection'),
      backgroundColor: (Colors.redAccent),
      action: SnackBarAction(
        label: 'dismiss',
        onPressed: () {},
      ),
    );
  }
}
