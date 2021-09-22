# FeatherAPI
A lightweight backend api framework for dart  
⚠️ **under construction**

## QuickStart
```dart

import "feather_api/feather_api.dart";

class MyController extends Controller {
  @override
  String get baseUrl => "/";
  
  @GET("")
  Future<Response> myPostMethod(ParsedRequest req) async {
    return Response.json({"msg": "Hello World"});
  }
}

void main() async {
  Application app = new Application();
  
  app.registerController(MyController(app));
  await app.run();
}

```
