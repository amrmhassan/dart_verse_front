import 'dart:io';
import 'package:path/path.dart';
import 'package:frontend/package/constants/header_fields.dart';

class HeadersUtils {
  static Map<String, String> addFileHeaders(
    Map<String, String> headers,
    File file,
  ) {
    headers[HeaderFields.disposition] = 'filename=${basename(file.path)};';
    headers[HttpHeaders.contentLengthHeader] = file.lengthSync().toString();
    return headers;
  }
}
