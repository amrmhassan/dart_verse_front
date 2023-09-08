import 'package:dio/dio.dart';
import 'package:frontend/package/errors/verse_exception.dart';

class DioErrorTrans {
  static Future<T> run<T>(Future<T> Function() callback) async {
    try {
      var res = await callback();
      return res;
    } on DioException catch (e) {
      var data = e.response?.data;
      String? message = data['error'];
      String? code = data['code'];
      throw VerseException(message ?? 'No message', code);
    }
  }
}
