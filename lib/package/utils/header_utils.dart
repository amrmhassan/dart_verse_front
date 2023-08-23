import 'dart:io';

import 'package:frontend/package/constants/header_fields.dart';
import 'package:frontend/replacable_utils/path_utils.dart';

class HeadersUtils {
  static Map<String, String> addFileHeaders(
    Map<String, String> headers,
    File file,
  ) {
    headers[HeaderFields.disposition] =
        'filename=${PathUtils.basename(file.path)};';
    headers[HttpHeaders.contentLengthHeader] = file.lengthSync().toString();
    return headers;
  }
}
