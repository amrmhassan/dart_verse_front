import 'package:frontend/package/errors/verse_exception.dart';

class DbException extends VerseException {
  DbException(String message) : super(message, 'db-error');
}

class DbNotConnectedException extends DbException {
  DbNotConnectedException()
      : super(
          'Db not set up yet!',
        );
}
