import 'package:DocuSort/app/product/cache/hive/hive_cache_manager.dart';
import 'package:DocuSort/app/product/cache/hive/operation/theme_operation.dart';
import 'package:DocuSort/app/product/manager/device_info/device_info_manager.dart';
import 'package:DocuSort/app/product/manager/getIt/getIt_manager.dart';
import 'package:DocuSort/app/product/model/theme/theme_model.dart';
import 'package:DocuSort/app/product/package/uuid/id_generator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final class AppInit {
  const AppInit._();

  static Future<void> mainInit() async {
    WidgetsFlutterBinding.ensureInitialized();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    await EasyLocalization.ensureInitialized();
    GetItManager.setup();
    await HiveCacheManager().start();
    await _startInitialHiveOperations();
  }

  static Future<void> splashInit() async {
    await DeviceInfoManager().init();
  }

  static Future<void> _startInitialHiveOperations() async {
    final ThemeOperation themeOperation = GetItManager.getIt<ThemeOperation>();

    await themeOperation.start(ThemeModel.themeModelKey);
    if (themeOperation.getItem(ThemeModel.themeModelKey)?.id == null) {
      await themeOperation.addOrUpdateItem(
        ThemeModel(
          id: IdGenerator.randomIntId,
          isLight: true,
        ),
      );
    }
  }
}
