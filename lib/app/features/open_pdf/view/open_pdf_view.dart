import 'package:DocuSort/app/features/home/view/features/home_pdf/model/pdf_model.dart';
import 'package:DocuSort/app/features/open_pdf/bloc/open_pdf_cubit.dart';
import 'package:DocuSort/app/features/open_pdf/bloc/open_pdf_state.dart';
import 'package:DocuSort/app/features/open_pdf/view/component/open_pdf_bottom_bar/bloc/open_pdf_buttom_bar_cubit.dart';
import 'package:DocuSort/app/features/open_pdf/view/component/open_pdf_bottom_bar/view/open_pdf_bottom_bar_view.dart';
import 'package:DocuSort/app/features/open_pdf/view/component/search_pdf_pop_up/view/search_pdf_pop_up_view.dart';
import 'package:DocuSort/app/product/component/alert_dialog/show_dialog.dart';
import 'package:DocuSort/app/product/component/custom_pdf_view/model/custom_pdf_view_model.dart';
import 'package:DocuSort/app/product/component/custom_pdf_view/view/custom_pdf_view.dart';
import 'package:DocuSort/app/product/component/text/locale_text.dart';
import 'package:DocuSort/app/product/package/uuid/id_generator.dart';
import 'package:DocuSort/generated/locale_keys.g.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

@RoutePage()
class OpenPdfView extends StatefulWidget {
  const OpenPdfView({
    super.key,
    required this.pdfModel,
  });

  final PdfModel pdfModel;

  @override
  State<OpenPdfView> createState() => _OpenPdfViewState();
}

class _OpenPdfViewState extends State<OpenPdfView> {
  final PdfViewerController _pdfViewerController = PdfViewerController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => OpenPdfCubit(
            widget.pdfModel,
          )..initDatabase(),
        ),
        BlocProvider(
          create: (_) => OpenPdfBottomBarCubit(),
        ),
      ],
      child: Scaffold(
        appBar: _getAppBar(context: context),
        body: BlocConsumer<OpenPdfCubit, OpenPdfState>(
          builder: (context, state) {
            switch (state.status) {
              case OpenPdfStatus.start:
                return _getCircularProgressIndicator();
              case OpenPdfStatus.initial:
                return Stack(
                  children: [
                    CustomPdfView(
                      pdfSettingsModel: state.pdfSettingsModel!,
                      customPdfViewModel: CustomPdfViewModel(
                        id: IdGenerator.randomIntId,
                        pdfModel: state.pdfModel,
                      ),
                      pdfViewerController: _pdfViewerController,
                    ),
                    const Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: OpenPdfBottomBarView(),
                    ),
                  ],
                );
              case OpenPdfStatus.loading:
                return _getCircularProgressIndicator();
              case OpenPdfStatus.error:
                return const LocaleText(
                  text: LocaleKeys.customPdfView_errorWhileLoadingPdf,
                );
            }
          },
          listener: (context, state) {},
        ),
      ),
    );
  }

  AppBar _getAppBar({required BuildContext context}) {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          context.router.maybePop();
        },
        icon: const Icon(
          Icons.arrow_back,
        ),
      ),
      title: const LocaleText(text: LocaleKeys.openPdf_viewPdf),
      actions: [
        _getSearchButton(),
      ],
    );
  }

  Widget _getCircularProgressIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _getSearchButton() {
    return BlocBuilder<OpenPdfCubit, OpenPdfState>(
      builder: (context, state) {
        switch (state.status) {
          case OpenPdfStatus.start:
            return const SizedBox();
          case OpenPdfStatus.initial:
            return IconButton(
              onPressed: () {
                IShowDialog(
                  context: context,
                  widget: SearchPdfPopUpView(
                    pdfViewerController: _pdfViewerController,
                  ),
                ).getDialog();
              },
              icon: const Icon(Icons.search),
            );
          case OpenPdfStatus.loading:
          case OpenPdfStatus.error:
            return const SizedBox();
        }
      },
    );
  }
}