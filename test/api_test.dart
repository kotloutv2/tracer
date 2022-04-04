import 'package:flutter_test/flutter_test.dart';
import 'package:tracer/services/api.dart';

void main() {
  test('Test get vitals for Garfield', () async {
    final lasagnaVitals = await Api.getVitals('lasagna.lover@tabby.com');
    assert(lasagnaVitals.isNotEmpty);
  });
}
