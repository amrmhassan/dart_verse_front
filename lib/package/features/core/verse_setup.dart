import 'dart:async';
import 'package:frontend/package/constants/header_fields.dart';
import 'package:frontend/package/constants/runtime_variables.dart';
import 'package:frontend/package/constants/setup_constants.dart';
import 'package:frontend/package/errors/models/app_exceptions.dart';
import 'package:frontend/package/features/auth/auth_utils.dart';
import 'package:flutter/material.dart';
import 'package:frontend/package/features/auth/models/user_model.dart';
import 'package:frontend/package/features/auth/user_controller.dart';
import 'package:frontend/package/features/core/models/setup_model.dart';
import 'package:frontend/package/features/endpoints/constants/endpoints_constants.dart';
import 'package:frontend/package/helpers/hive/hive_helper.dart';
import 'package:frontend/package/helpers/hive/hive_initiator.dart';
import 'package:hive/hive.dart';

late StreamController<VerseUser?> _userStreamController;
const Duration _urlBaseConnectTimeoutDefault = Duration(seconds: 5);
late Box _setUpBox;
late SetupModel _setupModel;

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

  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await HiveInitiator().setup();
    _setUpBox = await HiveBox.setup;
    _setupModel = SetupModel(baseUrl: baseUrl, appId: appId);
    //? here ensure you initialize all dio stuff

    _initDio();

    _userStreamController = StreamController<VerseUser?>();
    //! reload the user on every initialization & make it optional
    // first check if the baseUrl is a live
    await _validateBaseUrl();

    await _saveSetupModel();
    await _loadUser();
  }

  void _initDio() async {
    if (appId != null) {
      dio.options.headers[HeaderFields.appId] = appId;
    }
    dio.options.baseUrl = baseUrl;
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
        EndpointsConstants.serverAlive,
      );
      finished = true;
    } catch (e) {
      throw BaseUrlException();
    }
  }

  Future<void> _saveSetupModel() async {
    await _setUpBox.put(SetupConstants.setup, _setupModel);
  }

  static VerseSetup get instance {
    var setUp = _setUpBox.get(SetupConstants.setup) as SetupModel?;
    if (setUp == null) {
      throw VerseNotInitializedException();
    }

    return VerseSetup(
      baseUrl: setUp.baseUrl,
      appId: setUp.appId,
    );
  }

  Future<void> _loadUser() async {
    VerseUser? user = UserController(_setUpBox).currentUser();
    _userStreamController.add(user);
  }

  static StreamController<VerseUser?> get userStreamController =>
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
    String? jwt = UserController(_setUpBox).userJWT();

    return AuthUtils.attachAuthHeader(jwt, headers);
  }

  static Box get setupBox => _setUpBox;
}
