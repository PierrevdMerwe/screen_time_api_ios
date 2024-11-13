import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'screen_time_api_ios_platform_interface.dart';

class MethodChannelScreenTimeApiIos extends ScreenTimeApiIosPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('screen_time_api_ios');

  Future<bool> requestPermission() async {
    try {
      final result = await methodChannel.invokeMethod<bool>('requestPermission');
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<void> selectAppsToDiscourage() async {
    await methodChannel.invokeMethod('selectAppsToDiscourage');
  }

  Future<void> encourageAll() async {
    await methodChannel.invokeMethod('encourageAll');
  }
}