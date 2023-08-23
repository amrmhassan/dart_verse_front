class EndpointsConstants {
  // server
  static const String serverAlive = '/checkServerAlive';

  // auth
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyEmail = '/verifyEmail';
  static const String getVerificationEmail = '/getVerificationEmail';
  static const String changePassword = '/changePassword';
  static const String forgetPassword = '/forgetPassword';
  static const String logoutFromAllDevices = '/logoutFromAllDevices';
  static const String logout = '/logout';
  static const String updateUserData = '/updateUserData';
  static const String deleteUserData = '/deleteUserData';
  static const String fullyDeleteUser = '/fullyDeleteUser';

  // storage
  static const String uploadFile = '/upload';
  static String downloadFile(
    String bucketName,
    String filePath,
  ) =>
      '/download/$bucketName/$filePath';

  static const String deleteFile = '/delete';

  // db
  static const String getDbConnLink = '/getDbConnLink';
}
