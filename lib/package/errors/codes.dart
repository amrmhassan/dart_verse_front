class ExceptionsCodes {
  //? app errors
  static const String verseNotInitializedCode = 'verse-not-initialized';
  static const String baseUrlErrorCode = 'base-url-not-valid';
  static const String baseUrlConnectTimeoutErrorCode =
      'base-url-connect-timeout';
  //? auth errors
  static const String noUserLoggedIn = 'no-user-logged-in';
  static const String jwtIsNull = 'saved-jwt-is-null';

  //? storage errors
  static const String fileNotFound = 'file-not-found';
  static const String fileNotFoundOnBucket = 'file-not-found-on-bucket';
  static const String fileAlreadyDownloaded = 'file-already-downloaded';
  //? app check
  static const String secretKeysNull = 'secret-keys-null';
}
