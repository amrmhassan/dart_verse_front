import 'dart:async';
import 'package:dio/dio.dart';
import 'package:frontend/package/constants/header_fields.dart';
import 'package:frontend/package/constants/runtime_variables.dart';
import 'package:frontend/package/constants/setup_constants.dart';
import 'package:frontend/package/errors/models/app_exceptions.dart';
import 'package:frontend/package/errors/verse_exception.dart';
import 'package:frontend/package/features/app_check/app_check.dart';
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
late String? _appApiKey;
late String? _appApiSecretKey;

class VerseSetup {
  final String baseUrl;
  final bool checkServer;
  final String? _apiKey;
  final String? _apiSecretKey;

  final Duration _baseUrlConnectTimeout;

  VerseSetup({
    required this.baseUrl,
    this.checkServer = false,
    String? apiKey,
    String? apiSecretKey,
    Duration baseUrlConnectTimeout = _urlBaseConnectTimeoutDefault,
  })  : _apiSecretKey = apiSecretKey,
        _baseUrlConnectTimeout = baseUrlConnectTimeout,
        _apiKey = apiKey;

  Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await HiveInitiator().setup();
    _setUpBox = await HiveBox.setup;
    _setupModel = SetupModel(baseUrl: baseUrl);
    _appApiKey = _apiKey;
    _appApiSecretKey = _apiSecretKey;

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
    dio.options.baseUrl = baseUrl;
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (options.path == EndpointsConstants.serverTime) {
          return handler.next(options);
        }
        String? apiEncrypter = await AppCheck.instance.getApiHash();
        if (apiEncrypter != null) {
          options.headers[HeaderFields.apiHash] = apiEncrypter;
          options.headers[HeaderFields.apiKey] = apiKey;
        }
        String? jwt = UserController(_setUpBox).userJWT();

        if (jwt != null) {
          options.headers[HeaderFields.authorization] =
              '${HeaderFields.bearer} $jwt';
        }
        return handler.next(options);
      },
    ));
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
    } on DioException catch (e) {
      var response = e.response;
      String? message = response?.data?['error'];
      String? code = response?.data?['code'];
      throw VerseException(message ?? 'Unknown message', code);
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
    );
  }

  Future<void> _loadUser() async {
    VerseUser? user = UserController(_setUpBox).currentUser();
    _userStreamController.add(user);
  }

  static StreamController<VerseUser?> get userStreamController =>
      _userStreamController;

  /// this will attach app id and authorization headers
  // static Map<String, String> attachAuthHeaders(Map<String, String> headers) {
  //   String? jwt = UserController(_setUpBox).userJWT();

  //   return AuthUtils.attachAuthHeader(jwt, headers);
  // }

  static Box get setupBox => _setUpBox;
  static String? get apiKey => _appApiKey;
  static String? get apiSecretKey => _appApiSecretKey;
}
