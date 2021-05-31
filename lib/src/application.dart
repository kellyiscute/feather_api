import 'dart:io';
import 'dart:mirrors';

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
}
