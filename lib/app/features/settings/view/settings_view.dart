import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_app/app/core/extention/build_context/build_context_extension.dart';
import 'package:pdf_app/app/core/extention/localization/localization_extention.dart';
import 'package:pdf_app/app/core/extention/string/null_string_extention.dart';
import 'package:pdf_app/app/features/settings/view/component/settings_list_tile.dart';
import 'package:pdf_app/app/features/settings/view/settings_view_mixin.dart';
import 'package:pdf_app/app/product/bloc/theme/theme_cubit.dart';
import 'package:pdf_app/app/product/bloc/theme/theme_state.dart';
import 'package:pdf_app/app/product/component/text/locale_text.dart';
import 'package:pdf_app/app/product/navigation/app_router.dart';
import 'package:pdf_app/generated/locale_keys.g.dart';

@RoutePage()
class SettingsView extends StatelessWidget with SettingsViewMixin {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(
        context: context,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.sized.widthNormalValue,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                return SettingsListTile(
                  leading: Icon(
                    isThemeLight(state.theme)
                        ? Icons.sunny
                        : Icons.sunny_snowing,
                    size: 30,
                    color: context.theme.getColor.iconColor,
                  ),
                  traling: Switch(
                    value: isThemeLight(state.theme),
                    onChanged: (bool value) {
                      context.read<ThemeCubit>().setTheme();
                    },
                    activeColor: context.theme.getColor.focusColor,
                  ),
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            SettingsListTile(
              onTap: () {
                context.router.push(const LanguageRoute());
              },
              leading: Icon(
                Icons.language,
                size: 30,
                color: context.theme.getColor.iconColor,
              ),
              traling: Image.asset(
                context.locale.getFlagAsset.forNull.getImageNotFoundAsset,
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _getAppBar({
    required BuildContext context,
  }) =>
      AppBar(
        title: LocaleText(
          text: LocaleKeys.general_settings,
          textStyle: context.theme.getTextStyle.headline1,
        ),
      );
}