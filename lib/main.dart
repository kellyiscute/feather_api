import 'package:featherApi/featherApi.dart';
import 'package:featherApi/src/response.dart';

class MyController extends Controller {
  @override
  String get baseUrl => "/";

  MyController(Application app) : super(app) {
    post(
      "/<str:name>",
      myRequestHandler,
    );
  }

  Future<Response> myRequestHandler(req) async {
    app.logger.i(req.headers["asdf"]);
    return Response.json(req.body)
      ..headers.addAll(
        {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "*",
          "Access-Control-Allow-Headers": "*",
        },
      );
  }
}

void main() async {
  Application application = Application(port: 8770);

  application.registerController(MyController(application));
  await application.run();
}
