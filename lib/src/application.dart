import 'dart:io';
import 'dart:mirrors';

import 'package:featherApi/src/extend.dart';
import 'package:featherApi/src/route.dart';

class Application {
  final InternetAddress listenAddr;
  final int listenPort;

  Application([String address = "0.0.0.0", int port = 8080])
      : this.listenAddr = InternetAddress(address),
        this.listenPort = port;
}
