import 'package:frontend/package/errors/codes.dart';
import 'package:frontend/package/errors/verse_exception.dart';

class AuthException extends VerseException {
  AuthException(super.message, super.code);
}

class NoUserLoggedInException extends AuthException {
  NoUserLoggedInException()
      : super(
          'No user logged in',
          ExceptionsCodes.noUserLoggedIn,
        );
}

class JwtIsNullException extends AuthException {
  JwtIsNullException()
      : super(
          'saved jwt is null',
          ExceptionsCodes.jwtIsNull,
        );
}
