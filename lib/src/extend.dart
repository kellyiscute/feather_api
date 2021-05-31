import 'dart:html';

import 'package:featherApi/featherApi.dart';

typedef RequestHandlerDelegate = Future<void> Function(HttpRequest req);

abstract class Controller {
  String get baseUrl;
  String get debugName => "<no-name>";
  Application _app;
  Application get app => _app;

  Controller(this._app);

  Future<bool> resolveUrl() async => true;
  void route(String method, String route, void Function() handler) {}

  void post(String route, void Function() handler) {
    this.route("POST", route, handler);
  }

  void get() {}
}
