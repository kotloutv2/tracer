import 'package:flutter_test/flutter_test.dart';
import 'package:tracer/services/api.dart';

void main() {
  test('Test get vitals for Garfield', () async {
    var vitals = await Api.getVitals('lasagna.lover@tabby.com');
    assert(vitals.isNotEmpty);
    assert(vitals.length == 6);
  });
}
