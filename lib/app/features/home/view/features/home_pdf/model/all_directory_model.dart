import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:DocuSort/app/features/directory_add/model/directory_model.dart';
import 'package:DocuSort/app/product/cache/hive/model/hive_model.dart';

part 'all_directory_model.freezed.dart';
part 'all_directory_model.g.dart';

@freezed
@HiveType(typeId: 0)
class AllDirectoryModel with _$AllDirectoryModel, HiveModelMixin {
  factory AllDirectoryModel({
    @HiveField(0) int? id,
    @HiveField(1) List<DirectoryModel?>? allDirectory,
  }) = _AllDirectoryModel;

  factory AllDirectoryModel.fromJson(Map<String, dynamic> json) =>
      _$AllDirectoryModelFromJson(json);

  AllDirectoryModel._();

  AllDirectoryModel fromJson(Map<String, dynamic> json) =>
      AllDirectoryModel.fromJson(json);

  static const String allDirectoryKey = 'allDirectory';

  @override
  String get key {
    return allDirectoryKey;
  }
}