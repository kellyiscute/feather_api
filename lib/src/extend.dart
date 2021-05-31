import 'dart:html';

import 'package:featherApi/featherApi.dart';

import '../featherApi.dart';
import '../featherApi.dart';

typedef RequestHandlerDelegate = Future<void> Function(HttpRequest req);

abstract class Controller {
  String get baseUrl;
  String get debugName => "<no-name>";
  final Map<CompiledRoute, RequestHandlerDelegate> compiledRoutePattern = {};
  final List<Pattern> routes = [];
  Application _app;
  Application get app => _app;

  Controller(this._app);

  Future<bool> resolveUrl() async => true;

  String getRegexRep(String type) {
    switch (type) {
      case "int":
        return r"[0-9]*";
      case "str":
        return r"A-z0-9_-";
      case "any":
        return r".*";
      default:
        throw UnimplementedError("url param type not implemented");
    }
  }

  void route(HttpMethod method, String route, RequestHandlerDelegate handler) {
    RegExp match = RegExp(r"\/\<(?<type>((str)|(int))):(?<name>[A-z_]*)\>\/?");
    String compiledRegex = route;
    match.allMatches(route).forEach((m) {
      assert(m.groupNames.contains("name") && m.groupNames.contains("type"));
      final String paramName = m.namedGroup("name")!;
      final String type = m.namedGroup("type")!;
      compiledRegex = compiledRegex.replaceAll(
        m.group(0)!,
        "?<$paramName>${getRegexRep(type)}",
      );
    });
    this.compiledRoutePattern[
        CompiledRoute(match: compiledRegex, method: method)] = handler;
  }

  void post(String route, RequestHandlerDelegate handler) {
    this.route(HttpMethod.POST, route, handler);
  }

  void get() {}
}
