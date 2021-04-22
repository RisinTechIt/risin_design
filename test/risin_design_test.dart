import 'package:flutter_test/flutter_test.dart';
import 'package:risin_design/common_utils.dart';

import 'package:risin_design/risin_design.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('custom authenticated backend requests', () async {
    SharedPreferences.setMockInitialValues({});
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('token', 'efeffemrfwkoqoeqo');
    final backend = CustomRestAuth(baseUrl: 'https://jsonplaceholder.typicode.com');
    var resp = await backend.authGet('/todos/1');
    expect(resp.statusCode, 200);
  });
}
