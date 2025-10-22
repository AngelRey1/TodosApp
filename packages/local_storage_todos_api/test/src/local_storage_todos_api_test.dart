// Not required for test files

import 'package:flutter_test/flutter_test.dart';
import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('LocalStorageTodosApi', () {
    test('can be instantiated', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final api = LocalStorageTodosApi(plugin: prefs);
      expect(api, isNotNull);
    });
  });
}
