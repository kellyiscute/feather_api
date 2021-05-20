import 'package:featherApi/featherApi.dart';
import 'package:featherApi/src/extend.dart';
import 'package:test/test.dart';

class DemoController extends Controller {}

void main() {
  group('A group of tests', () {
    var application = Application();
    application.registerController<DemoController>();
  });
}
