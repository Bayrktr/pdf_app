import 'package:DocuSort/app/features/home/view/features/home_directory/model/pdf_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:DocuSort/app/features/open_pdf/bloc/open_pdf_state.dart';
import 'package:DocuSort/app/product/cache/hive/operation/pdf_settings_operation.dart';
import 'package:DocuSort/app/product/manager/getIt/getIt_manager.dart';
import 'package:DocuSort/app/product/model/pdf_settings/pdf_settings_model.dart';
import 'package:DocuSort/app/product/package/uuid/id_generator.dart';

class OpenPdfCubit extends Cubit<OpenPdfState> {
  OpenPdfCubit(this.pdfModel)
      : super(
          OpenPdfState(
            pdfModel: pdfModel,
          ),
        );

  final PdfModel pdfModel;

  final PdfSettingsOperation _pdfSettingsOperation =
      GetItManager.getIt<PdfSettingsOperation>();



  Future<void> initDatabase() async {
    emit(
      state.copyWith(
        status: OpenPdfStatus.loading,
      ),
    );

    await _pdfSettingsOperation.start(
      PdfSettingsModel.pdfSettingsModelKey,
    );

    PdfSettingsModel? pdfSettingsModel =  _getPdfSettingsModel();
    if (pdfSettingsModel == null) {
      _createFirstModel();
      pdfSettingsModel = _getPdfSettingsModel();
    }

    await Future.delayed(const Duration(seconds: 1));

    emit(
      state.copyWith(
        pdfSettingsModel: pdfSettingsModel,
        status: OpenPdfStatus.initial,
      ),
    );
  }

  Future<void> _createFirstModel() async {
    await _pdfSettingsOperation.addOrUpdateItem(
      PdfSettingsModel(
        id: IdGenerator.randomIntId,
      ),
    );
  }

  PdfSettingsModel? _getPdfSettingsModel() {
    return _pdfSettingsOperation.getItem(
      PdfSettingsModel.pdfSettingsModelKey,
    );
  }
}
