import 'package:frontend/package/features/utils/string_utils.dart';

class PathUtils {
  static String basename(String path) {
    path = path.replaceAll('\\', '/');
    return path.strip('/').split('/').last;
  }
}
