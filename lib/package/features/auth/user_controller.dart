import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:frontend/package/errors/models/auth_exception.dart';
import 'package:frontend/package/features/core/verse_setup.dart';

class UserController {
  final String _dataDir;
  UserController(this._dataDir);

  Stream<User?> userChanges() {
    return VerseSetup.userStreamController.stream;
  }

  // this will receive user data and jwt
  Future<User> saveUser({
    required String jwt,
    required String email,
    required String id,
    Map<String, dynamic>? userData,
  }) async {
    User userModel = User(
      jwt: jwt,
      email: email,
      userData: userData,
      id: id,
    );
    var newUser = json.encode(userModel.toJSON());
    String userFilePath = '$_dataDir/user';
    File userFile = File(userFilePath);
    await userFile.writeAsString(newUser);
    VerseSetup.userStreamController.add(userModel);
    return userModel;
  }

  Future<void> logout() async {
    // delete the user data file from the app data
    String userFilePath = '$_dataDir/user';
    File userFile = File(userFilePath);
    if (userFile.existsSync()) {
      userFile.deleteSync();
      VerseSetup.userStreamController.add(null);
    } else {
      throw NoUserLoggedInException();
    }
  }

  User? currentUser() {
    String userFilePath = '$_dataDir/user';
    File userFile = File(userFilePath);
    if (!userFile.existsSync()) return null;
    var userJson = json.decode(userFile.readAsStringSync());
    return User.fromJSON(userJson);
  }

  String? userJWT() {
    return currentUser()?._jwt;
  }
}

class User {
  final String id;
  final String email;
  final Map<String, dynamic>? userData;
  final String _jwt;

  const User({
    required this.id,
    required this.email,
    required this.userData,
    required String jwt,
  }) : _jwt = jwt;

  Map<String, dynamic> toJSON() {
    return {
      'jwt': _jwt,
      'email': email,
      'userData': json.encode(userData),
      '_id': id,
    };
  }

  static User fromJSON(Map<String, dynamic> obj) {
    String? userData = obj['userData'];
    var userDataJson = userData == null ? null : json.decode(userData);
    return User(
      id: obj['_id'],
      jwt: obj['jwt'],
      email: obj['email'],
      userData: userDataJson,
    );
  }
}
