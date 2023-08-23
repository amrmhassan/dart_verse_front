import 'package:frontend/package/features/db/coll_ref_utils.dart';
import 'package:frontend/package/features/db/mongo_db/mongo_db_collection.dart';
import 'package:frontend/package/features/db/path_entity.dart';
import 'package:frontend/package/features/db/repositories/coll_ref_repo.dart';
import 'package:frontend/package/features/db/repositories/db_entity.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'doc_ref_mongo.dart';

class CollRefMongo extends MongoDbCollection implements DbEntity, CollRefRepo {
  @override
  final String name;
  @override
  final DocRefMongo? parentDoc;
  final Db _db;

  CollRefMongo(this.name, this.parentDoc, this._db)
      : super(_db, CollRefUtils.getCollId(name, parentDoc));

  @override
  String get id => CollRefUtils.getCollId(name, parentDoc);

  @override
  PathEntity get path => CollRefUtils.getCollPath(this, name, parentDoc);

  @override
  DocRefMongo doc([String? id]) {
    //! apply doc id restriction
    String docId = id ?? ObjectId().toHexString();
    return DocRefMongo(docId, this, _db);
  }
}
