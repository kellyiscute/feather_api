import 'package:featherApi/featherApi.dart';
import 'package:featherApi/src/response.dart';

void main() async {
  Application application = Application(port: 8770);

  application.registerController(MyController(application));
  await application.run();
}

class MyController extends Controller {
  MyController(Application app) : super(app) {
    get(
      "",
      (req) async => Response.json({"msg": "ok"})
        ..headers.addAll(
          {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Method": "*",
            "Access-Control-Allow-Headers": "*",
          },
        ),
    );
  }

  @override
  String get baseUrl => "";
}
