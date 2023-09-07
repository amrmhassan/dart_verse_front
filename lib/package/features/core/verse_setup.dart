import 'dart:async';
import 'dart:io';

import 'package:frontend/package/constants/header_fields.dart';
import 'package:frontend/package/constants/runtime_variables.dart';
import 'package:frontend/package/errors/models/app_exceptions.dart';
import 'package:frontend/package/features/auth/auth_utils.dart';
import 'package:flutter/material.dart';
import 'package:frontend/package/features/auth/user_controller.dart';
import 'package:frontend/package/features/endpoints/constants/endpoints_constants.dart';
import 'package:frontend/package/helpers/hive/hive_initiator.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

late Directory _tempDir;
late StreamController<User?> _userStreamController;
const Duration _urlBaseConnectTimeoutDefault = Duration(seconds: 5);

class VerseSetup {
  final String baseUrl;
  final String? appId;
  final bool checkServer;
  final Duration _baseUrlConnectTimeout;

  VerseSetup({
    required this.baseUrl,
    this.checkServer = false,
    this.appId,
    Duration baseUrlConnectTimeout = _urlBaseConnectTimeoutDefault,
  }) : _baseUrlConnectTimeout = baseUrlConnectTimeout;

  static Directory get dataDir => _tempDir;

  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await HiveInitiator().setup();
    //? here ensure you initialize all dio stuff

    _initDio();

    _userStreamController = StreamController<User?>();
    _tempDir = await path_provider.getApplicationDocumentsDirectory();
    //! reload the user on every initialization & make it optional
    // first check if the baseUrl is a live
    await _validateBaseUrl();

    await _writeBaseUrl();
    await _writeAppId();
    await _loadUser();
  }

  void _initDio() async {
    if (appId != null) {
      dio.options.headers[HeaderFields.appId] = appId;
    }
  }

  Future<void> _validateBaseUrl() async {
    bool finished = false;
    Future.delayed(_baseUrlConnectTimeout).then((value) {
      if (!finished) {
        throw BaseUrlConnectionTimeoutException();
      }
    });

    //! in this validate just send your app id to the server and check it in a custom endpoint
    if (!checkServer) return;
    try {
      await dio.get(
        baseUrl + EndpointsConstants.serverAlive,
      );
      finished = true;
    } catch (e) {
      throw BaseUrlException();
    }
  }

  Future<void> _writeBaseUrl() async {
    String baseUrlPath = '${_tempDir.path}/${DataFiles.baseUrl}';
    File baseUrlFile = File(baseUrlPath);
    await baseUrlFile.writeAsString(baseUrl);
  }

  Future<void> _writeAppId() async {
    if (appId == null) return;
    String appIdPath = '${_tempDir.path}/${DataFiles.appId}';
    File appIdFile = File(appIdPath);
    await appIdFile.writeAsString(appId!);
  }

  static VerseSetup get instance {
    String baseUrlPath = '${_tempDir.path}/${DataFiles.baseUrl}';
    String appIdPath = '${_tempDir.path}/${DataFiles.appId}';
    File baseUrlFile = File(baseUrlPath);
    File appIdFile = File(appIdPath);
    String? appId;

    if (!baseUrlFile.existsSync()) {
      throw VerseNotInitializedException();
    }
    if (appIdFile.existsSync()) {
      appId = appIdFile.readAsStringSync();
    }
    String baseUrl = baseUrlFile.readAsStringSync();

    return VerseSetup(
      baseUrl: baseUrl,
      appId: appId,
    );
  }

  Future<void> _loadUser() async {
    User? user = UserController(_tempDir.path).currentUser();
    _userStreamController.add(user);
  }

  static StreamController<User?> get userStreamController =>
      _userStreamController;

  /// this will attach app id and authorization headers
  static Map<String, String> attachAuthHeaders(
    Map<String, String> headers, {
    VerseSetup? instance,
  }) {
    VerseSetup verseSetup = instance ?? VerseSetup.instance;

    if (verseSetup.appId != null) {
      headers[HeaderFields.appId] = verseSetup.appId!;
    }
    String? jwt = UserController(_tempDir.path).userJWT();

    return AuthUtils.attachAuthHeader(jwt, headers);
  }
}

class DataFiles {
  static const String baseUrl = 'baseUrl';
  static const String appId = 'appId';
}
