// ignore_for_file: library_private_types_in_public_api

import 'package:frontend/package/constants/runtime_variables.dart';
import 'package:frontend/package/features/endpoints/constants/endpoints_constants.dart';

class VerseServices {
  static _VerseServicesExecuter get instance {
    return _VerseServicesExecuter();
  }
}

class _VerseServicesExecuter {
  Future<DateTime> getServerTime() async {
    var res = await dio.get(EndpointsConstants.serverTime);
    var date = DateTime.parse(res.data);
    return date;
  }
}
