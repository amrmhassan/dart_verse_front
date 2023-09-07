// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VerseUserAdapter extends TypeAdapter<VerseUser> {
  @override
  final int typeId = 1;

  @override
  VerseUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VerseUser(
      id: fields[0] as String,
      email: fields[1] as String,
      userData: (fields[2] as Map?)?.cast<String, dynamic>(),
      jwt: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VerseUser obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.userData)
      ..writeByte(3)
      ..write(obj.jwt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerseUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerseUser _$VerseUserFromJson(Map<String, dynamic> json) => VerseUser(
      id: json['id'] as String,
      email: json['email'] as String,
      userData: json['userData'] as Map<String, dynamic>?,
      jwt: json['jwt'] as String,
    );

Map<String, dynamic> _$VerseUserToJson(VerseUser instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'userData': instance.userData,
      'jwt': instance.jwt,
    };
