// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend/package/constants/runtime_variables.dart';
import 'package:frontend/package/constants/body_fields.dart';
import 'package:frontend/package/errors/models/auth_exception.dart';
import 'package:frontend/package/features/auth/auth_utils.dart';
import 'package:frontend/package/features/auth/models/user_model.dart';
import 'package:frontend/package/features/auth/user_controller.dart';
import 'package:frontend/package/features/core/verse_setup.dart';
import 'package:frontend/package/features/endpoints/impl/default_auth_endpoints.dart';
import 'package:frontend/package/features/endpoints/repo/auth_endpoint.dart';
import 'package:frontend/package/features/utils/exception_transformer.dart';
import 'package:frontend/package/utils/dio_error_trans.dart';

class VerseAuth {
  static _VerseAuthExecuter get instance {
    return _VerseAuthExecuter();
  }
}

class _VerseAuthExecuter {
  late AuthEndpoints _authEndpoints;
  UserController get _userController => UserController(VerseSetup.setupBox);

  _VerseAuthExecuter({
    AuthEndpoints? authEndpoints,
  }) {
    _authEndpoints = authEndpoints ?? DefaultAuthEndpoints();
  }

  Future<VerseUser> registerEmailPassword({
    required String email,
    required String password,
    Map<String, dynamic>? userData,
  }) async {
    String url = _authEndpoints.register;

    Map<String, dynamic> body = {
      BodyFields.email: email,
      BodyFields.password: password,
    };

    if (userData != null) {
      body[BodyFields.userData] = userData;
    }

    // here i should send a register request to the server with custom endpoints
    var response = await DioErrorTrans.run(() => dio.post(
          url,
          data: json.encode(body),
        ));

    return _afterAuth(response, email);

    // then handling the jwt and save it to the documents file
    // then send an update to the auth service stream with the new user changes
  }

  Future<VerseUser> _afterAuth(Response response, String email) async {
    int? code = response.statusCode;
    var resBody = response.data;
    if (code != 200) {
      //? if not success then throw an error
      String? error = resBody['error'];
      String? code = resBody['code'];
      throw AuthException(error ?? 'Unknown error', code);
    }
    // if continue this means that the user is successfully logged in
    var data = resBody['data'];
    var userData = data[BodyFields.userData];
    String id = userData['_id'];
    userData.remove('_id');
    String jwt = data['jwt'];
    //! i must return user data with the response from the backend
    var user = await _userController.saveUser(
      jwt: jwt,
      email: email,
      userData: userData,
      id: id,
      // userData: make the user data return from the backend,
    );
    return user;
  }

  Future<VerseUser> loginEmailPassword({
    required String email,
    required String password,
  }) async {
    String url = _authEndpoints.login;

    Map<String, dynamic> body = {
      BodyFields.email: email,
      BodyFields.password: password,
    };
    var response = await DioErrorTrans.run(() => dio.post(
          url,
          data: json.encode(body),
        ));

    return _afterAuth(response, email);
  }

  Future<void> logout({
    bool logoutFromBackend = true,
  }) async {
    if (logoutFromBackend) {
      Map<String, String> headers = {};
      String? jwt = _userController.userJWT();
      if (jwt == null) {
        throw JwtIsNullException();
      }

      headers = AuthUtils.attachAuthHeader(jwt, headers);
      String url = _authEndpoints.logout;
      var res = await dio.post(url, options: Options(headers: headers));
      ExceptionTransformer.authException(res);
    }
    // sending logout request to the backend
    return _userController.logout();
  }

  VerseUser? get currentUser {
    // here just reload the user from the user controller
    return _userController.currentUser();
  }

  Stream<VerseUser?> get userChanges => _userController.userChanges();

  bool get userLoggedIn => _userController.currentUser() != null;
}
