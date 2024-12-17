// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pdf_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PdfModelAdapter extends TypeAdapter<PdfModel> {
  @override
  final int typeId = 2;

  @override
  PdfModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PdfModel(
      id: fields[1] as int?,
      name: fields[2] as String?,
      fileTypeEnum: fields[3] as FileTypeEnum?,
      byte: fields[4] as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, PdfModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.fileTypeEnum)
      ..writeByte(4)
      ..write(obj.byte);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PdfModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PdfModelImpl _$$PdfModelImplFromJson(Map<String, dynamic> json) =>
    _$PdfModelImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      fileTypeEnum:
          $enumDecodeNullable(_$FileTypeEnumEnumMap, json['fileTypeEnum']),
      byte: const Uint8ListConverter().fromJson(json['byte'] as String?),
    );

Map<String, dynamic> _$$PdfModelImplToJson(_$PdfModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'fileTypeEnum': _$FileTypeEnumEnumMap[instance.fileTypeEnum],
      'byte': const Uint8ListConverter().toJson(instance.byte),
    };

const _$FileTypeEnumEnumMap = {
  FileTypeEnum.pdf: 'pdf',
};