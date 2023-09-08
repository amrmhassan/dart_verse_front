// ignore_for_file: library_private_types_in_public_api

class AppCheck {
  static _AppCheckExecuter get instance {
    return _AppCheckExecuter();
  }
}

class _AppCheckExecuter {
  Future<String> getServerTime() async {
    return 'date';
  }
}
