import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'screen_time_api_ios_method_channel.dart';

abstract class ScreenTimeApiIosPlatform extends PlatformInterface {
  ScreenTimeApiIosPlatform() : super(token: _token);

  static final Object _token = Object();
  static ScreenTimeApiIosPlatform _instance = MethodChannelScreenTimeApiIos();

  static ScreenTimeApiIosPlatform get instance => _instance;
  
  static set instance(ScreenTimeApiIosPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> requestPermission() {
    throw UnimplementedError('requestPermission() has not been implemented.');
  }

  Future<void> selectAppsToDiscourage() {
    throw UnimplementedError('selectAppsToDiscourage() has not been implemented.');
  }

  Future<void> encourageAll() {
    throw UnimplementedError('encourageAll() has not been implemented.');
  }
}