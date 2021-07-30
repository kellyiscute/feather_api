import 'dart:io';

import 'package:featherApi/featherApi.dart';
import 'package:featherApi/src/request.dart';
import 'package:featherApi/src/response.dart';

import '../featherApi.dart';

typedef RequestHandlerDelegate = Future<Response> Function(ParsedRequest req);

abstract class Controller {
  String get baseUrl;
  String get debugName => "<no-name>";
  final Map<String, RequestHandlerDelegate> directPattern = {};
  final Map<CompiledRoute, RequestHandlerDelegate> compiledRoutePattern = {};
  final List<Pattern> routes = [];
  final Application _app;
  Application get app => _app;

  Controller(this._app);

  Future<void> resolve(HttpRequest request) async {
    String path = request.requestedUri.path;
    print(path);
    Response? response;
    if (directPattern.containsKey(path)) {
      final parsed = ParsedRequest(request);
      await parsed.parse();
      response = await directPattern[path]!(parsed);
    } else {
      for (var pattern in compiledRoutePattern.entries) {
        var result = pattern.key.resolves(path);
        if (result != null) {
          final parsed = ParsedRequest(request, urlParams: result);
          await parsed.parse();
          response = await pattern.value(parsed);
          break;
        }
      }
    }

    if (response == null) {
      _app.logger.e("404");
      request.response.statusCode = 404;
      await request.response.close();
    }
    await response?.constructResponse(request);
    await request.response.close();
  }

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
    if (compiledRegex == route) {
      this.directPattern[route] = handler;
      return;
    }
    compiledRegex += r"$";
    this.compiledRoutePattern[
        CompiledRoute(match: RegExp(compiledRegex), method: method)] = handler;
  }

  void post(String route, RequestHandlerDelegate handler) {
    this.route(HttpMethod.POST, route, handler);
  }

  void get(String route, RequestHandlerDelegate handler) {
    this.route(HttpMethod.GET, route, handler);
  }

  void patch(String route, RequestHandlerDelegate handler) {
    this.route(HttpMethod.PATCH, route, handler);
  }

  void delete(String route, RequestHandlerDelegate handler) {
    this.route(HttpMethod.DELETE, route, handler);
  }

  void put(String route, RequestHandlerDelegate handler) {
    this.route(HttpMethod.PUT, route, handler);
  }

  void options(String route, RequestHandlerDelegate handler) {
    this.route(HttpMethod.OPTIONS, route, handler);
  }
}
