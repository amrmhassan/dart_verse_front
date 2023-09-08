import 'package:frontend/package/errors/codes.dart';
import 'package:frontend/package/errors/verse_exception.dart';

class AppCheckExceptions extends VerseException {
  AppCheckExceptions(super.message, super.code);
}

class SecretKeysNullException extends AppCheckExceptions {
  SecretKeysNullException()
      : super(
          'Please provide both secret keys from your backend provider, to the verse setup initialization',
          ExceptionsCodes.secretKeysNull,
        );
}
