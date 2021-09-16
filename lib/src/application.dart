import 'dart:io';
import 'dart:mirrors';

import 'package:featherApi/featherApi.dart';
import 'package:featherApi/src/annotations.dart';
import 'package:featherApi/src/request.dart';
import 'package:featherApi/src/response.dart';
import 'package:logger/logger.dart';
import 'package:pedantic/pedantic.dart';

typedef RequestInterceptor = Future<void> Function(ParsedRequest);
typedef ResponseInterceptor = Future<void> Function(ParsedRequest, Response);

class Application {
  final InternetAddress listenAddr;
  final int listenPort;
  final List<Controller> _controllers = [];
  final List _requestInterceptors = [];
  final List _responseIntercepotors = [];
  final Logger logger;

  Application({String address = "0.0.0.0", int port = 8080})
      : this.listenAddr = InternetAddress(address),
        this.listenPort = port,
        this.logger =
            Logger(printer: PrettyPrinter(), filter: ProductionFilter());

  void registerAnnotatedMethods(Controller controller) {
    final mirror = reflect(controller);
    for (final member in mirror.type.instanceMembers.entries) {
      if (member.value.metadata.isNotEmpty) {
        member.value.metadata.forEach((element) {
          if (element.type.isSubclassOf(reflectClass(ControllerMethods))) {
            if (element.reflectee is GET) {
              controller.route(
                HttpMethod.GET,
                element.reflectee.path,
                (req) => mirror.invoke(member.key, [req]).reflectee,
              );
            }
            if (element.reflectee is POST) {
              controller.route(
                HttpMethod.POST,
                element.reflectee.path,
                (req) => mirror.invoke(member.key, [req]).reflectee,
              );
            }
            if (element.reflectee is PUT) {
              controller.route(
                HttpMethod.PUT,
                element.reflectee.path,
                (req) => mirror.invoke(member.key, [req]).reflectee,
              );
            }
            if (element.reflectee is PATCH) {
              controller.route(
                HttpMethod.PATCH,
                element.reflectee.path,
                (req) => mirror.invoke(member.key, [req]).reflectee,
              );
            }
            if (element.reflectee is DELETE) {
              controller.route(
                HttpMethod.DELETE,
                element.reflectee.path,
                (req) => mirror.invoke(member.key, [req]).reflectee,
              );
            }
            if (element.reflectee is OPTIONS) {
              controller.route(
                HttpMethod.OPTIONS,
                element.reflectee.path,
                (req) => mirror.invoke(member.key, [req]).reflectee,
              );
            }
          }
        });
      }
    }
  }

  void registerController(Controller controller) {
    _controllers.add(controller);
  }

  void useRequestInterceptor(RequestInterceptor interceptor) {
    _requestInterceptors.add(interceptor);
  }

  void useResponseInterceptor(ResponseInterceptor interceptor) {
    _responseIntercepotors.add(interceptor);
  }

  Future<void> run() async {
    HttpServer server = await HttpServer.bind(listenAddr, listenPort);
    logger.i(
        "Server started at $listenAddr:$listenPort with ${_controllers.length} controller registered");
    await for (final request in server) {
      unawaited(Future.forEach<Controller>(_controllers, (c) async {
        await c.resolve(request);
      }));
    }
  }
}
