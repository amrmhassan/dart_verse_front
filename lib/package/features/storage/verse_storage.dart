// ignore_for_file: library_private_types_in_public_api

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:frontend/package/constants/header_fields.dart';
import 'package:frontend/package/errors/models/storage_exceptions.dart';
import 'package:frontend/package/features/core/verse_setup.dart';
import 'package:frontend/package/features/endpoints/constants/endpoints_constants.dart';
import 'package:frontend/package/features/storage/constants/storage_constants.dart';
import 'package:frontend/package/features/storage/utils/upload_file_utils.dart';
import 'package:frontend/package/features/utils/exception_transformer.dart';
import 'package:frontend/package/features/utils/string_utils.dart';
import 'package:frontend/package/utils/header_utils.dart';
import 'package:frontend/package/constants/runtime_variables.dart';

class VerseStorage {
  static _VerseStorageExecuter get instance {
    return const _VerseStorageExecuter();
  }
}

class _VerseStorageExecuter {
  const _VerseStorageExecuter();

  Future<String> putFile(
    File file, {
    String? bucketName,
    String? ref,
    FileExistReaction? onFileExist,
    String? fileName,
  }) async {
    if (!file.existsSync()) {
      throw FileNotFound(file.path);
    }
    String url = EndpointsConstants.uploadFile;

    Map<String, String> headers = {};

    // putting file info

    headers = HeadersUtils.addFileHeaders(headers, file);

    // adding parameters to headers
    if (bucketName != null) {
      headers[HeaderFields.bucketName] = bucketName;
    }
    if (ref != null) {
      headers[HeaderFields.ref] = ref;
    }
    // adding the normal headers
    String? onFileExistReaction = UploadFileUtils.mapException(onFileExist);
    if (onFileExistReaction != null) {
      headers[HeaderFields.onFileExist] = onFileExistReaction;
    }
    if (fileName != null) {
      headers[HeaderFields.fileName] = fileName;
    }

    headers = VerseSetup.attachAuthHeaders(headers);
    var res = await dio.post(
      url,
      data: file.readAsBytesSync(),
      options:
          Options(headers: headers, contentType: ContentType.binary.mimeType),
    );
    ExceptionTransformer.storageException(
      res,
      bucketName: bucketName,
      fileRef: ref,
    );
    var body = res.data as Map<String, dynamic>;
    String data = body['data'];
    return data;
  }

  Future<void> delete(
    String ref, {
    String? bucketName,
  }) async {
    Map<String, String> headers = {};

    headers = VerseSetup.attachAuthHeaders(headers);
    if (bucketName != null) {
      headers[HeaderFields.bucketName] = bucketName;
    }
    headers[HeaderFields.ref] = ref;
    String url = EndpointsConstants.deleteFile;

    var res = await dio.delete(
      url,
      options: Options(headers: headers),
    );
    ExceptionTransformer.storageException(
      res,
      bucketName: bucketName,
      fileRef: ref,
    );
  }

  Future<void> downloadFile({
    required String bucketName,
    required String fileRef,
    required String downloadDir,
    String? customFileName,
    bool forceDownload = false,
  }) async {
    String fileName = customFileName ?? fileRef.split('/').last;
    String downloadPath = '${downloadDir.strip('/')}/$fileName';
    // if the forceDownload is false
    // check if the file already exists and throw an error that the file already exist
    if (!forceDownload) {
      File checkerFile = File(downloadPath);
      if (checkerFile.existsSync()) {
        throw FileAlreadyDownloaded(downloadPath);
      }
    }
    String url = EndpointsConstants.downloadFile(bucketName, fileRef);
    Map<String, String> headers = {};

    headers = VerseSetup.attachAuthHeaders(headers);
    var res = await dio.get(
      url,
      options: Options(headers: headers),
    );
    ExceptionTransformer.storageException(
      res,
      bucketName: bucketName,
      fileRef: fileRef,
    );

    File file = File(downloadPath);
    file.writeAsBytesSync(res.data);
    print('file downloaded');
  }
}
