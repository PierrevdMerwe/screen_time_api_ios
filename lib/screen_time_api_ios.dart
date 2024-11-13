import 'package:flutter/foundation.dart';
import 'screen_time_api_ios_platform_interface.dart';
import 'screen_time_api_ios_method_channel.dart';

class ScreenTimeApiIos {
  Future<bool> requestPermission() async {
    final instance = ScreenTimeApiIosPlatform.instance as MethodChannelScreenTimeApiIos;
    return await instance.requestPermission();
  }

  Future<void> selectAppsToDiscourage() async {
    final instance = ScreenTimeApiIosPlatform.instance as MethodChannelScreenTimeApiIos;
    await instance.selectAppsToDiscourage();
  }

  Future<void> encourageAll() async {
    final instance = ScreenTimeApiIosPlatform.instance as MethodChannelScreenTimeApiIos;
    await instance.encourageAll();
  }
}