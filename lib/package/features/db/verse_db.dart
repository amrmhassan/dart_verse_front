// ignore_for_file: library_private_types_in_public_api

import 'package:frontend/package/constants/runtime_variables.dart';
import 'package:frontend/package/errors/models/db_exceptions.dart';
import 'package:frontend/package/features/db/db_connector.dart';
import 'package:frontend/package/features/db/mongo_ref/coll_ref_mongo.dart';
import 'package:mongo_dart/mongo_dart.dart';

String? _dbConnLink;
Db? _db;

class VerseDb {
  static _VerseDbExecuter get instance {
    return const _VerseDbExecuter();
  }
}

class _VerseDbExecuter {
  const _VerseDbExecuter();

  Db get db {
    if (_db == null) {
      throw DbNotConnectedException();
    }
    return _db!;
  }

  /// this must run one time before any use of db
  Future<Db> setupDb() async {
    if (_db == null) {
      await _getConnLink();
      await _connectDb();
      return db;
    } else {
      return db;
    }
  }
  //? mongodb://localhost:27017

  Future<void> _getConnLink() async {
    _dbConnLink = await DbConnector.getConnLink();
  }

  Future<void> _connectDb() async {
    //? here i will connect to db with mongo db driver
    _db = await DbConnector.connectDb(_dbConnLink!);
    verseLogger.i('connected to db');
  }

  CollRefMongo collection(String name) {
    CollRefMongo collRef = CollRefMongo(name, null, db);
    return collRef;
  }
}
