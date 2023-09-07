import 'package:hive_flutter/hive_flutter.dart';

class HiveBox {
  static Future<Box> customBox(String name) async {
    return Hive.openBox(name);
  }

  static Future<Box> get setup => Hive.openBox(_HiveBoxesNames.setup);
}

class _HiveBoxesNames {
  static const String setup = 'setup';
}
