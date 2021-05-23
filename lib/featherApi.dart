/// Support for doing something awesome.
///
/// More dartdocs go here.
library featherApi;

import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

export 'src/application.dart';
export 'src/annotations.dart';
export 'src/extend.dart';
export 'src/url_resolver.dart';

// TODO: Export any libraries intended for clients of this package.

void main(List<String> args) async {
  HttpServer httpServer = await HttpServer.bind("127.0.0.1", 9000);
  BytesBuilder builder = BytesBuilder();
  List<Uint8List> lines = [];
  httpServer.listen((req) {
    String sBoundary = req.headers.contentType!.parameters["boundary"]!;
    int boundary1 = AsciiEncoder().convert(sBoundary)[0];
    int boundaryLast = sBoundary.codeUnitAt(sBoundary.length - 1);
    List<int> bBoundary =
        AsciiEncoder().convert(sBoundary).toList(growable: false);
    req.listen(
      (data) {
        data.forEach((element) {
          builder.addByte(element);
          Uint8List b = builder.toBytes();
          if (element == boundaryLast) {
            if (builder.length >= bBoundary.length) {
              lines.add(builder.toBytes());
              print(AsciiDecoder().convert(b
                  .getRange(b.length - bBoundary.length - 1, b.length)
                  .toList()));
            }
          }
        });
      },
      onDone: () {
        lines.forEach((element) {
          if (element.take(bBoundary.length).toList() == bBoundary) {
            print("boundary!");
          }
        });
      },
    );
  });
}
