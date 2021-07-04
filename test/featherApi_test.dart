import 'package:featherApi/featherApi.dart';
import 'package:featherApi/src/response.dart';
import 'package:test/test.dart';

class C extends Controller {
  C(Application app) : super(app) {
    post("/", (req) async => Response());
  }

  @override
  String get baseUrl => "/";
}

void main() async {
  var application = Application("127.0.0.1", 9800);
  application.registerController(C(application));
  await application.run();
}
