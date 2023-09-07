import 'dart:async';
import 'package:frontend/package/constants/setup_constants.dart';
import 'package:frontend/package/errors/models/auth_exception.dart';
import 'package:frontend/package/features/auth/models/user_model.dart';
import 'package:frontend/package/features/core/verse_setup.dart';
import 'package:hive/hive.dart';

class UserController {
  final Box setupBox;
  UserController(this.setupBox);

  Stream<VerseUser?> userChanges() {
    return VerseSetup.userStreamController.stream;
  }

  // this will receive user data and jwt
  Future<VerseUser> saveUser({
    required String jwt,
    required String email,
    required String id,
    Map<String, dynamic>? userData,
  }) async {
    VerseUser userModel = VerseUser(
      jwt: jwt,
      email: email,
      userData: userData,
      id: id,
    );
    await setupBox.put(SetupConstants.user, userModel);
    VerseSetup.userStreamController.add(userModel);
    return userModel;
  }

  Future<void> logout() async {
    // delete the user data file from the app data
    var user = setupBox.get(SetupConstants.user) as VerseUser?;
    if (user != null) {
      await setupBox.delete(SetupConstants.user);
      VerseSetup.userStreamController.add(null);
    } else {
      throw NoUserLoggedInException();
    }
  }

  VerseUser? currentUser() {
    var user = setupBox.get(SetupConstants.user) as VerseUser?;
    return user;
  }

  String? userJWT() {
    return currentUser()?.jwt;
  }
}
