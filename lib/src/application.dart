import 'dart:io';

import 'package:featherApi/featherApi.dart';
import 'package:logger/logger.dart';
import 'package:pedantic/pedantic.dart';

class Application {
  final InternetAddress listenAddr;
  final int listenPort;
  final List<Controller> _controllers = [];
  final Logger logger;

  Application({String address = "0.0.0.0", int port = 8080})
      : this.listenAddr = InternetAddress(address),
        this.listenPort = port,
        this.logger = Logger(printer: PrettyPrinter());

  void registerController(Controller controller) {
    _controllers.add(controller);
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
