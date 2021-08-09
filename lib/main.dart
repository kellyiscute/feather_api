import 'package:featherApi/featherApi.dart';
import 'package:featherApi/src/response.dart';

class MyController extends Controller {
  MyController(Application app) : super(app) {
    get(
      "/<str:name>",
      (req) async => Response.json(req.urlParams)
        ..headers.addAll(
          {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "*",
            "Access-Control-Allow-Headers": "*",
          },
        ),
    );
    options(
      "/<str:name>",
      (req) async => Response.json({"msg": "ok"})
        ..headers.addAll(
          {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "*",
            "Access-Control-Allow-Headers": "*",
          },
        ),
    );
  }

  @override
  String get baseUrl => "/";
}

void main() async {
  Application application = Application(port: 8770);

  application.registerController(MyController(application));
  await application.run();
}
