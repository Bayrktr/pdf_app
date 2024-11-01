import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:DocuSort/app/core/constant/settings.dart';
import 'package:DocuSort/app/core/extention/build_context/build_context_extension.dart';
import 'package:DocuSort/app/features/splash/bloc/splash_cubit.dart';
import 'package:DocuSort/app/features/splash/bloc/splash_state.dart';
import 'package:DocuSort/app/product/component/image/custom_image.dart';
import 'package:DocuSort/app/product/navigation/app_router.dart';

@RoutePage()
class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => SplashCubit()..startApp(),
        child: BlocConsumer<SplashCubit, SplashState>(
          builder: (context, state) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.sized.widthNormalValue,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomImage(
                      imageFrom: ImageFrom.ASSET,
                      assetPath: 'asset/image/logo/app_icon.png',
                      height: context.sized.dynamicWidth(0.50),
                      width: context.sized.dynamicWidth(0.50),
                    ),
                    Text(
                      Settings.appName,
                      style: context.theme.getTextStyle.mediumHeadline1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const LinearProgressIndicator(),
                  ],
                ),
              ),
            );
          },
          listener: (context, state) {
            switch (state.status) {
              case SplashStatus.start:
                return;
              case SplashStatus.error:
                return;
              case SplashStatus.finish:
                context.router.popAndPush(const HomeRoute());
            }
          },
        ),
      ),
    );
  }
}