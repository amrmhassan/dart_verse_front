class StorageConstants {}

enum FileExistReaction {
  /// this will override the original file with the same name on the remote storage
  override,

  /// this will throw an error that the file already exists
  error,

  /// this will just return the path of the original file and ignore the upload new file process
  ignore,
}
