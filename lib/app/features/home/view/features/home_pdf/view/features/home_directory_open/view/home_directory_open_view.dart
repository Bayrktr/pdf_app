import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:DocuSort/app/core/extention/build_context/build_context_extension.dart';
import 'package:DocuSort/app/core/extention/string/null_string_extention.dart';
import 'package:DocuSort/app/core/extention/string/string_extention.dart';
import 'package:DocuSort/app/features/directory_add/model/directory_model.dart';
import 'package:DocuSort/app/features/home/view/features/home_pdf/view/features/home_directory_open/cubit/home_directory_open_cubit.dart';
import 'package:DocuSort/app/features/home/view/features/home_pdf/view/features/home_directory_open/cubit/home_directory_open_state.dart';
import 'package:DocuSort/app/features/home/view/features/home_pdf/view/features/home_directory_open/view/component/home_directory_open_show_model_sheet.dart';
import 'package:DocuSort/app/features/home/view/features/home_pdf/view/features/home_directory_open/view/component/home_directory_open_snack_bar.dart';
import 'package:DocuSort/app/product/component/alert_dialog/show_dialog.dart';
import 'package:DocuSort/app/product/component/text/locale_text.dart';
import 'package:DocuSort/app/product/navigation/app_router.dart';
import 'package:DocuSort/generated/locale_keys.g.dart';

@RoutePage()
class HomeDirectoryOpenView extends StatelessWidget {
  const HomeDirectoryOpenView({
    super.key,
    this.directoryModel,
  });

  final DirectoryModel? directoryModel;

  @override
  Widget build(BuildContext context) {
    if (directoryModel == null) {
      return const SizedBox();
    }

    return Scaffold(
      floatingActionButton: _getFloatingActionButton(
        context: context,
        directoryModel: directoryModel!,
      ),
      appBar: _getAppBar(context: context),
      body: BlocProvider(
        create: (_) => HomeDirectoryOpenCubit(
          directoryModel?.pdfListKey,
        ),
        child: BlocConsumer<HomeDirectoryOpenCubit, HomeDirectoryOpenState>(
            builder: (context, state) {
          if (state.status == HomeDirectoryOpenStatus.start) {
            context.read<HomeDirectoryOpenCubit>().initDatabase();
          }

          switch (state.status) {
            case HomeDirectoryOpenStatus.start:
              return _getCircularProgress(context: context);
            case HomeDirectoryOpenStatus.initial:
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.sized.widthNormalValue,
                ),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final item = state.allPdfModel?.allPdf?[index];
                    if (item == null) return const SizedBox();

                    return ListTile(
                      onTap: () {
                        context.router.push(
                          OpenPdfRoute(
                            pdfModel: item,
                          ),
                        );
                      },
                      leading: Text(
                        item.name.forNull.getGeneralNullMessage,
                        style: context.theme.getTextStyle.bodyText1,
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          IShowDialog(
                            context: context,
                            widget: HomeDirectoryOpenShowModelSheet(
                              pdfModel: item,
                              onEdit: () {
                                context.router.push(
                                  EditPdfRoute(
                                    pdfModel: item,
                                  ),
                                );
                              },
                              onDelete: () {
                                context
                                    .read<HomeDirectoryOpenCubit>()
                                    .deletePdfFromDirectory(item);
                              },
                            ),
                          ).showBottomSheet();
                        },
                        icon: const Icon(
                          Icons.more_vert,
                        ),
                      ),
                    );
                  },
                  itemCount: state.allPdfModel?.allPdf?.length ?? 0,
                ),
              );
            case HomeDirectoryOpenStatus.loading:
              return _getCircularProgress(context: context);
            case HomeDirectoryOpenStatus.error:
              return const LocaleText(
                text: LocaleKeys.errors_nullErrorMessage,
              );
          }
        }, listener: (context, state) {
          switch (state.snackBarStatus) {
            case HomeDirectoryOpenSnackBarStatus.initial:
              return;
            case HomeDirectoryOpenSnackBarStatus.deletedSuccess:
              HomeDirectoryOpenSnackBar(
                message:
                    LocaleKeys.editDirectory_pdfDeletedSuccessfully.lang.tr,
                color: Colors.lightGreen,
              ).show(context);
          }
        }),
      ),
    );
  }

  Widget _getCircularProgress({required BuildContext context}) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  AppBar _getAppBar({required BuildContext context}) {
    return AppBar(
      centerTitle: true,

      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () {
          context.router.maybePop();
        },
        icon: const Icon(Icons.arrow_back),
      ),
      title: const LocaleText(
        text: LocaleKeys.directoryOpen_selectPdf,
      ),
    );
  }

  FloatingActionButton _getFloatingActionButton({
    required BuildContext context,
    required DirectoryModel directoryModel,
  }) {
    return FloatingActionButton(
      onPressed: () {
        context.router.push(
          AddPdfRoute(
            directoryModel: directoryModel,
          ),
        );
      },
      heroTag: 'addPdf',
      child: const Icon(Icons.add),
    );
  }
}