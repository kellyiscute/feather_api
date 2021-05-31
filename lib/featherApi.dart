/// Support for doing something awesome.
///
/// More dartdocs go here.
library featherApi;

import 'dart:io';
export 'src/application.dart';
export 'src/extend.dart';
export 'src/url_resolver.dart';

// TODO: Export any libraries intended for clients of this package.

void main(List<String> args) async {
  HttpServer httpServer = await HttpServer.bind("127.0.0.1", 9000);
}
