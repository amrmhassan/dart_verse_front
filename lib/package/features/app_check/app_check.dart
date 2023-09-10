// ignore_for_file: library_private_types_in_public_api

import 'package:frontend/package/errors/models/app_check_error.dart';
import 'package:frontend/package/features/app_check/datasoueces/api_encoder.dart';
import 'package:frontend/package/features/core/verse_setup.dart';
import 'package:frontend/package/features/services/verse_services.dart';

class AppCheck {
  static _AppCheckExecuter get instance {
    return _AppCheckExecuter();
  }
}

class _AppCheckExecuter {
  Future<String?> getApiHash() async {
    String? apiKey = VerseSetup.apiKey;
    if (apiKey == null) return null;
    String? apiSecretKey = VerseSetup.apiSecretKey;
    if (apiSecretKey == null) {
      throw SecretKeysNullException();
    }
    ApiEncoder encoder = ApiEncoder(
      secretKey: apiSecretKey,
      encrypterSecretKey: apiSecretKey,
    );
    DateTime dateTime = await VerseServices.instance.getServerTime();
    String encoded = encoder.encoded(apiKey, dateTime);
    return encoded;
  }
}
