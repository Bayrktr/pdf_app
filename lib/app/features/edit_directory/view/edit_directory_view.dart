import 'package:DocuSort/app/core/extention/build_context/build_context_extension.dart';
import 'package:DocuSort/app/core/extention/string/null_string_extention.dart';
import 'package:DocuSort/app/core/extention/string/string_extention.dart';
import 'package:DocuSort/app/features/directory_add/model/directory_model.dart';
import 'package:DocuSort/app/features/edit_directory/bloc/edit_directory_cubit.dart';
import 'package:DocuSort/app/features/edit_directory/bloc/edit_directory_state.dart';
import 'package:DocuSort/app/features/edit_directory/view/component/edit_directory_show_model_sheet.dart';
import 'package:DocuSort/app/features/edit_directory/view/component/edit_directory_snack_bar.dart';
import 'package:DocuSort/app/product/component/alert_dialog/show_dialog.dart';
import 'package:DocuSort/app/product/component/text/locale_text.dart';
import 'package:DocuSort/app/product/navigation/app_router.dart';
import 'package:DocuSort/app/product/utility/validator/text_form_field_validator.dart';
import 'package:DocuSort/generated/locale_keys.g.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'edit_directory_mixin.dart';

@RoutePage()
class EditDirectoryView extends StatelessWidget with _EditDirectoryMixin {
  EditDirectoryView({super.key, this.directoryModel});

  final DirectoryModel? directoryModel;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (directoryModel == null) {
      return Container();
    }

    return Scaffold(
      appBar: _getAppbar(
        context: context,
        directoryModel: directoryModel,
      ),
      body: BlocProvider(
        create: (_) => EditDirectoryCubit(directoryModel),
        child: BlocConsumer<EditDirectoryCubit, EditDirectoryState>(
          builder: (context, state) {
            if (state.status == EditDirectoryStatus.start) {
              context.read<EditDirectoryCubit>().initDatabase();
            }

            return Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.sized.widthNormalValue,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: context
                          .read<EditDirectoryCubit>()
                          .directoryNameController,
                      onChanged: (String? value) {
                        context
                            .read<EditDirectoryCubit>()
                            .editDirectoryName(value);
                      },
                      textAlign: TextAlign.center,
                      validator: (value) {
                        return TextFormFieldValidator(value: value)
                            .getEmptyCheckValidator;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    getAllPdfListViewBuilder(
                      state: state,
                      context: context,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    getAddPdfButton(
                        context: context, directoryModel: directoryModel!),
                    const SizedBox(
                      height: 20,
                    ),
                    getSaveButton(
                      status: state.status,
                      context: context,
                      onPressed: () {
                        if ((_formKey.currentState?.validate() ?? false) &&
                            state.status == EditDirectoryStatus.initial) {
                          context.read<EditDirectoryCubit>().updateDirectory();
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          listener: (context, state) {
            switch (state.allPdfSnackBarStatus) {
              case EditDirectoryAllPdfSnackBarStatus.initial:
                break;
              case EditDirectoryAllPdfSnackBarStatus.success:
                EditDirectorySnackBar(
                  message:
                      LocaleKeys.editDirectory_pdfDeletedSuccessfully.lang.tr,
                ).show(
                  context,
                );

              case EditDirectoryAllPdfSnackBarStatus.error:
                break;
            }
            switch (state.allDirectoryStatus) {
              case EditDirectoryAllDirectoryStatus.initial:
                break;

              case EditDirectoryAllDirectoryStatus.success:
                context.router.pushAndPopUntil(
                  const HomeDirectoryRoute(),
                  predicate: (_) => false,
                );
              case EditDirectoryAllDirectoryStatus.alreadyExist:
                EditDirectorySnackBar(
                  message:
                      LocaleKeys.editDirectory_pdfDeletedSuccessfully.lang.tr,
                ).show(
                  context,
                );

              case EditDirectoryAllDirectoryStatus.error:
                break;
            }
          },
        ),
      ),
    );
  }

  AppBar _getAppbar({
    required BuildContext context,
    DirectoryModel? directoryModel,
  }) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: const LocaleText(text: LocaleKeys.editDirectory_editDirectory),
      leading: IconButton(
        onPressed: () {
          context.router.popAndPush(
            const HomeDirectoryRoute(),
          );
        },
        icon: const Icon(
          Icons.arrow_back,
        ),
      ),
    );
  }
}
