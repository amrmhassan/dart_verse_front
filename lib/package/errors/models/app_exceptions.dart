import 'package:frontend/package/errors/codes.dart';
import 'package:frontend/package/errors/verse_exception.dart';

class AppExceptions extends VerseException {
  AppExceptions(super.message, super.code);
}

//? app exceptions
class VerseNotInitializedException extends AppExceptions {
  VerseNotInitializedException()
      : super(
          'verse not initialized, see the docs',
          ExceptionsCodes.verseNotInitializedCode,
        );
}

class BaseUrlException extends AppExceptions {
  BaseUrlException()
      : super(
          'can\'t connect to base url',
          ExceptionsCodes.baseUrlErrorCode,
        );
}

class BaseUrlConnectionTimeoutException extends AppExceptions {
  BaseUrlConnectionTimeoutException()
      : super(
          'can\'t connect to base url: timeout',
          ExceptionsCodes.baseUrlConnectTimeoutErrorCode,
        );
}
