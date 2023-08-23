abstract class VerseException implements Exception {
  final String message;
  final String? code;

  VerseException(this.message, this.code);

  @override
  String toString() {
    return '$runtimeType: $message \ncode: $code';
  }
}
