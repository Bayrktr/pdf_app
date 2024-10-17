import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_app/app/core/extention/build_context/build_context_extension.dart';
import 'package:pdf_app/app/core/extention/string/string_extention.dart';
import 'package:pdf_app/app/features/add_pdf/bloc/add_pdf_cubit.dart';
import 'package:pdf_app/app/features/add_pdf/bloc/add_pdf_state.dart';
import 'package:pdf_app/app/features/add_pdf/view/add_pdf_mixin.dart';
import 'package:pdf_app/app/features/add_pdf/view/component/add_pdf_snack_bar.dart';
import 'package:pdf_app/app/features/directory_add/model/directory_model.dart';
import 'package:pdf_app/app/product/component/text/locale_text.dart';
import 'package:pdf_app/app/product/utility/validator/text_form_field_validator.dart';
import 'package:pdf_app/generated/locale_keys.g.dart';

@RoutePage()
class AddPdfView extends StatelessWidget with AddPdfMixin {
  AddPdfView({
    super.key,
    this.directoryModel,
  });

  final DirectoryModel? directoryModel;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddPdfCubit(
        directoryModel: directoryModel,
      ),
      child: BlocConsumer<AddPdfCubit, AddPdfState>(
        builder: (context, state) {
          if (state.status == AddPdfStatus.start) {
            context.read<AddPdfCubit>().initDatabase();
          }
          return Scaffold(
            appBar: _getAppBar(
              context: context,
            ),
            body: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.sized.widthHighValue,
                ),
                child: Column(
                  children: [
                    Text(
                      state.selectedDirectory?.name ?? '',
                    ),
                    TextFormField(
                      controller: context.read<AddPdfCubit>().pdfNameController,
                      onChanged: (String? value) {
                        context.read<AddPdfCubit>().updatePdfName(value);
                      },
                      textAlign: TextAlign.center,
                      validator: (value) {
                        return TextFormFieldValidator(value: value)
                            .getEmptyCheckValidator;
                      },
                    ),
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(
                          Size(
                            context.sized.dynamicWidth(0.3),
                            context.sized.heightMediumValue,
                          ),
                        ),
                      ),
                      onPressed: () {
                        context.read<AddPdfCubit>().pickPdf();
                      },
                      label: Text('sec'),
                      icon: const Icon(Icons.file_upload),
                    ),
                    Text(state.pickFileResult.toString()),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if ((_formKey.currentState?.validate() ?? false) &&
                            state.status == AddPdfStatus.initial) {
                          context.read<AddPdfCubit>().savePdfToDirectory();
                        }
                      },
                      child: saveButtonWidget(state.status),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        listener: (context, state) {
          switch (state.savePdfStatus) {
            case SavePdfStatus.initial:
              return;
            case SavePdfStatus.fileError:
              AddPdfSnackBar(
                message: LocaleKeys.pdfAdd_fileWasNotAddedOrIncorrecty.lang.tr,
                color: Colors.redAccent,
              ).show(context);
            case SavePdfStatus.empty:
              return;
            case SavePdfStatus.success:
              context.router.maybePop();
            case SavePdfStatus.alreadyExist:
              AddPdfSnackBar(
                message: LocaleKeys.pdfAdd_thereIsAnotherPdfWithName.lang.tr,
                color: Colors.redAccent,
              ).show(context);
          }
        },
      ),
    );
  }

  AppBar _getAppBar({
    required BuildContext context,
  }) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () {
          context.router.maybePop();
        },
        icon: const Icon(
          Icons.arrow_back,
        ),
      ),
      title: const LocaleText(
        text: LocaleKeys.pdfAdd_pdfAdd,
      ),
    );
  }
}