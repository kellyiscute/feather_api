import 'dart:io';

import 'package:featherApi/featherApi.dart';
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
