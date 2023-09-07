import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class VerseUser {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String email;
  @HiveField(2)
  final Map<String, dynamic>? userData;
  @HiveField(3)
  final String jwt;

  const VerseUser({
    required this.id,
    required this.email,
    required this.userData,
    required this.jwt,
  });

  // factory VerseUser.fromJson(Map<String, dynamic> json) =>
  //     _$VerseUserFromJson(json);
  // Map<String, dynamic> toJson() => _$VerseUserToJson(this);
}
