import '../../constants/header_fields.dart';

class AuthUtils {
  static Map<String, String> attachAuthHeader(
    String? jwt,
    Map<String, String> headers,
  ) {
    if (jwt != null) {
      headers[HeaderFields.authorization] = '${HeaderFields.bearer} $jwt';
    }
    return headers;
  }
}
