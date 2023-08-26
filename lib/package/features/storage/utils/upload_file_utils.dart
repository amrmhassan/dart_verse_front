import 'package:frontend/package/features/storage/constants/storage_constants.dart';

class UploadFileUtils {
  static String? mapException(FileExistReaction? reaction) {
    if (reaction == null) return null;
    return reaction.name;
  }
}
