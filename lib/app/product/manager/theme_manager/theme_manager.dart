import 'package:flutter/material.dart';
import 'package:pdf_app/app/product/cache/hive/operation/theme_operation.dart';
import 'package:pdf_app/app/product/manager/getIt/getIt_manager.dart';
import 'package:pdf_app/app/product/model/theme/theme_model.dart';
import 'package:pdf_app/app/product/package/uuid/id_generator.dart';

class ThemeManager {
  // Private constructor to prevent external instantiation.
  ThemeManager._internal();

  // Static instance of the class.
  static final ThemeManager _instance = ThemeManager._internal();

  // Public factory method to access the instance.
  factory ThemeManager() {
    return _instance;
  }

  final ThemeOperation _themeOperation = GetItManager.getIt<ThemeOperation>();

  ThemeModel _themeModel = ThemeModel(
    id: null,
    themeData: ThemeData.dark(),
  );

  ThemeModel get themeModel => _themeModel;

  Future<void> initDatabase() async {
    print('init theme');
    await _themeOperation.start(ThemeModel.themeModelKey);

    final themeData = _themeOperation.getItem(ThemeModel.themeModelKey);

    print('theme data ${themeData?.themeData.toString()}');

    if (themeData == null) {
      await _createFirstThemeData();
      final newThemeData = _themeOperation.getItem(ThemeModel.themeModelKey);
      if (newThemeData == null) return;
      _themeModel = newThemeData;
    } else {
      _themeModel = themeData;
    }
  }

  Future<void> _createFirstThemeData() async {
    await _themeOperation.addOrUpdateItem(
      ThemeModel(
        id: IdGenerator.randomIntId,
        themeData: ThemeData.dark(),
      ),
    );
  }
}
