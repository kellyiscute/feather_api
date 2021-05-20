import 'dart:io';
import 'dart:mirrors';

import 'package:featherApi/src/annotations.dart';
import 'package:featherApi/src/extend.dart';
import 'package:featherApi/src/url_resolver.dart';

class Application {
  final InternetAddress listenAddr;
  final int listenPort;

  final Map<UrlResolver, dynamic Function()> _handlers =
      <UrlResolver, dynamic Function()>{};

  Application([String address = "0.0.0.0", int port = 8080])
      : this.listenAddr = InternetAddress(address),
        this.listenPort = port;

  void registerController<C extends Controller>() {
    UrlResolver? baseResolver;
    ClassMirror reflected = reflectClass(C);
    reflected.metadata.forEach((element) {
      if (element.reflectee is ControllerOf) {
        baseResolver = (element.reflectee as ControllerOf).resolver;
      }
    });
    if (baseResolver == null) {
      throw Exception("Controller with no ControllerOf annotation");
    }
    reflected.instanceMembers.forEach((key, value) {
      if (value.metadata.isNotEmpty) {
        value.metadata.forEach((element) {
          if (element.reflectee is Method) {}
        });
      }
    });
  }

  Future<void> run() async {
    HttpServer server = await HttpServer.bind(listenAddr, listenPort);
    server.listen((event) {});
  }
}
