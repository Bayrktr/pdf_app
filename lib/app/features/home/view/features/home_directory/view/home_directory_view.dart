import 'package:DocuSort/app/core/extention/build_context/build_context_extension.dart';
import 'package:DocuSort/app/core/extention/string/string_extention.dart';
import 'package:DocuSort/app/features/home/view/features/home_directory/bloc/home_directory_cubit.dart';
import 'package:DocuSort/app/features/home/view/features/home_directory/bloc/home_directory_state.dart';
import 'package:DocuSort/app/features/home/view/features/home_directory/view/component/layouts/home_directory_list_layout.dart';
import 'package:DocuSort/app/features/home/view/features/home_directory/view/component/layouts/home_directory_symbol_layout.dart';
import 'package:DocuSort/app/features/home/view/features/home_directory/view/component/show_modal/home_directory_app_bar_show_model_sheet.dart';
import 'package:DocuSort/app/features/home/view/features/home_directory/view/component/snack_bar/home_directory_snack_bar.dart';
import 'package:DocuSort/app/product/component/text/locale_text.dart';
import 'package:DocuSort/app/product/enum/page_layout_enum.dart';
import 'package:DocuSort/app/product/navigation/app_router.dart';
import 'package:DocuSort/generated/locale_keys.g.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_directory_mixin.dart';

@RoutePage()
class HomeDirectoryView extends StatelessWidget {
  const HomeDirectoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeDirectoryCubit()..initDatabase(),
      child: Scaffold(
        appBar: _getAppBar(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.router.push(DirectoryAddRoute());
          },
          heroTag: 'directory_add',
          child: const Icon(Icons.add),
        ),
        body: BlocConsumer<HomeDirectoryCubit, HomeDirectoryState>(
          listener: (context, state) {
            if (state.snackBarStatus ==
                HomeDirectorySnackBarStatus.deletedSuccess) {
              HomeDirectorySnackBar(
                message: LocaleKeys.home_directoryDeletedSuccessfully.lang.tr,
                duration: const Duration(seconds: 1),
              ).show(context);
            }
          },
          builder: (context, state) {
            switch (state.status) {
              case HomeDirectoryStatus.initial:
                return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.sized.widthNormalValue,
                    ),
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            context.router.push(const SearchDirectoryRoute());
                          },
                          child: const Icon(
                            Icons.search,
                          ),
                        ),
                        Expanded(
                          child: switch (
                              state.pageLayoutModel?.pageLayoutEnum) {
                            PageLayoutEnum.list => HomeDirectoryListLayout(
                                allDirectoryModel: state.allDirectory,
                              ),
                            PageLayoutEnum.symbol => HomeDirectorySymbolLayout(
                                allDirectoryModel: state.allDirectory,
                              ),
                            null => const SizedBox(),
                          },
                        ),
                      ],
                    ));

              case HomeDirectoryStatus.error:
                return const Center(
                  child: LocaleText(
                    text: LocaleKeys.errors_nullErrorMessage,
                  ),
                );

              case HomeDirectoryStatus.loading:
                return _getCircularProgressIndicator(context: context);
              case HomeDirectoryStatus.start:
                return _getCircularProgressIndicator(context: context);
            }
          },
        ),
      ),
    );
  }

  AppBar _getAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: LocaleText(
        text: LocaleKeys.home_directorys,
        textStyle: context.theme.getTextStyle.headline1,
      ),
      actions: [
        BlocBuilder<HomeDirectoryCubit, HomeDirectoryState>(
          builder: (context, state) {
            return IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (contextSecond) {
                    return BlocProvider.value(
                      value: BlocProvider.of<HomeDirectoryCubit>(context),
                      child: const HomeDirectoryAppBarShowModelSheet(),
                    );
                  },
                );
              },
              icon: const Icon(Icons.more_vert),
            );
          },
        ),
      ],
    );
  }

  Widget _getCircularProgressIndicator({required BuildContext context}) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}