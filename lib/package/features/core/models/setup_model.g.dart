// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setup_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SetupModelAdapter extends TypeAdapter<SetupModel> {
  @override
  final int typeId = 0;

  @override
  SetupModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SetupModel(
      baseUrl: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SetupModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.baseUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SetupModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
