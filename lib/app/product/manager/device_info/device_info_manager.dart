import 'dart:io';

import 'package:DocuSort/app/product/manager/device_info/platform_enum.dart';

class DeviceInfoManager {
  DeviceInfoManager._privateConstructor();

  static final DeviceInfoManager _instance = DeviceInfoManager._privateConstructor();

  factory DeviceInfoManager() {
    return _instance;
  }

  static PlatformEnum devicePlatform = PlatformEnum.ANDROID;

  Future<void> getDevicePlatform() async {
    if (Platform.isAndroid) {
      devicePlatform = PlatformEnum.ANDROID;
    } else {
      devicePlatform = PlatformEnum.IOS;
    }
  }

  Future<void> init() async {
    await getDevicePlatform();
  }
}