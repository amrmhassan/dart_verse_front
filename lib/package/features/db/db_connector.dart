import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend/package/constants/body_fields.dart';
import 'package:frontend/package/features/core/verse_setup.dart';
import 'package:frontend/package/features/endpoints/constants/endpoints_constants.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:frontend/package/constants/runtime_variables.dart';

class DbConnector {
  static Future<Db> connectDb(String uri) async {
    // 192.168.220.41:27017
    if (uri.startsWith('mongodb://')) {
      return _dnsConnect(uri);
    } else {
      return _normalConnect(uri);
    }
  }

//? mongodb://localhost:27017
  static Future<Db> _dnsConnect(String uri) async {
    Db db = await Db.create(uri);
    await db.open();
    return db;
  }

  static Future<Db> _normalConnect(String uri) async {
    Db db = Db(uri);
    await db.open();
    return db;
  }

  static Future<String> getConnLink(VerseSetup verseSetup) async {
    String url = verseSetup.baseUrl + EndpointsConstants.getDbConnLink;
    Map<String, String> headers = {};
    headers = VerseSetup.attachAuthHeaders(headers);
    var res = await dio.get(url, options: Options(headers: headers));
    var body = json.decode(res.data);
    String connLink = body[BodyFields.connLink];
    Uri baseUrl = Uri.parse(VerseSetup.instance.baseUrl);
    connLink = connLink.replaceAll('localhost', baseUrl.host);
    return connLink;
  }
}
