import 'package:frontend/package/features/db/path_entity.dart';
import 'package:frontend/package/features/db/repositories/db_entity.dart';
import 'package:frontend/package/features/db/repositories/doc_ref_repo.dart';

class CollRefUtils {
  static String getCollId(String name, DocRefRepo? parentDoc) {
    if (parentDoc == null) {
      return name;
    } else {
      return '$name|${parentDoc.id}|${parentDoc.parentColl.name}';
    }
  }

  static PathEntity getCollPath(
      DbEntity entity, String name, DocRefRepo? parentDoc) {
    if (parentDoc == null) {
      return PathEntity(
        name: name,
        entity: entity,
        parentPath: null,
      );
    } else {
      return PathEntity(
        name: name,
        entity: entity,
        parentPath: parentDoc.path,
      );
    }
  }
}
