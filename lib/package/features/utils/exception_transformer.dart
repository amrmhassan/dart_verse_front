import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:frontend/package/errors/models/auth_exception.dart';
import 'package:frontend/package/errors/models/storage_exceptions.dart';

class ExceptionTransformer {
  static void _validateServerExceptions(
    Response res,
    Function(String message, String? code) onError,
  ) {
    int? code = res.statusCode;
    if (code.toString().startsWith('4')) {
      var resBody = json.decode(res.data);
      //? if not success then throw an error
      String error = resBody['error'] ?? 'Unknown Error';
      String? code = resBody['code'];
      onError(error, code);
    } else if (code.toString().startsWith('5')) {
      var resBody = json.decode(res.data);
      //? if not success then throw an error
      String error = resBody['error'] ?? 'Unknown Error';
      String? code = resBody['code'];
      onError(error, code);
    }
  }

  static void authException(Response res) {
    return _validateServerExceptions(
      res,
      (message, code) {
        throw AuthException(message, code);
      },
    );
  }

  static void storageException(
    Response res, {
    String? bucketName,
    String? fileRef,
  }) {
    if (res.statusCode == HttpStatus.notFound) {
      throw FileNotFoundOnBucket(bucketName: bucketName, fileRef: fileRef);
    }
    return _validateServerExceptions(
      res,
      (message, code) {
        throw StorageException(message, code);
      },
    );
  }
}
