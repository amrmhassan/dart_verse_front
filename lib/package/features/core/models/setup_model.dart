import 'package:hive/hive.dart';
part 'setup_model.g.dart';

@HiveType(typeId: 0)
class SetupModel {
  @HiveField(0)
  final String baseUrl;
  @HiveField(1)
  final String? appId;

  const SetupModel({
    required this.baseUrl,
    required this.appId,
  });
}
