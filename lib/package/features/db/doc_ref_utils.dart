import 'package:frontend/package/features/db/path_entity.dart';
import 'package:frontend/package/features/db/repositories/coll_ref_repo.dart';
import 'package:frontend/package/features/db/repositories/db_entity.dart';

class DocRefUtils {
  static PathEntity getDocPath(
      String id, DbEntity entity, CollRefRepo parentColl) {
    return PathEntity(
      name: id,
      entity: entity,
      parentPath: parentColl.path,
    );
  }
}
