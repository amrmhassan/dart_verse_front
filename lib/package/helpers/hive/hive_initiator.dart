import 'package:frontend/package/features/auth/models/user_model.dart';
import 'package:frontend/package/features/core/models/setup_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveInitiator {
  Future<void> setup() async {
    await Hive.initFlutter();
    await _registerAdapters();
  }

  Future<void> _registerAdapters() async {
    Hive.registerAdapter(VerseUserAdapter()); //=>0
    Hive.registerAdapter(SetupModelAdapter()); //=>1
  }
}
