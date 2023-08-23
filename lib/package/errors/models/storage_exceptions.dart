import 'package:frontend/package/errors/codes.dart';
import 'package:frontend/package/errors/verse_exception.dart';

class StorageException extends VerseException {
  StorageException(super.message, super.code);
}

class FileNotFound extends StorageException {
  FileNotFound(String filePath)
      : super(
          'File not found locally: $filePath',
          ExceptionsCodes.fileNotFound,
        );
}

class FileNotFoundOnBucket extends StorageException {
  FileNotFoundOnBucket({
    String? bucketName,
    String? fileRef,
  }) : super(
          'File not found remotely on bucket $bucketName with ref $fileRef',
          ExceptionsCodes.fileNotFoundOnBucket,
        );
}

class FileAlreadyDownloaded extends StorageException {
  FileAlreadyDownloaded(String filePath)
      : super(
          'File already downloaded: $filePath',
          ExceptionsCodes.fileAlreadyDownloaded,
        );
}
