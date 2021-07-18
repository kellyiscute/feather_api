import 'dart:convert';
import 'dart:io';

import 'package:featherApi/src/multipart_file.dart';
import 'package:nanoid/async.dart';

abstract class Response {
  factory Response.json(Object data) {
    return JsonResponse(data);
  }
  Response();
  factory Response.XwwwFormUrlEncoded(Map<String, String> data) {
    return XwwwFormUrlEncodedResponse(data);
  }
  factory Response.formData() {
    throw UnimplementedError();
  }

  Future<void> constructResponse(HttpRequest request);
}

mixin ResponseConstructorMixin on Response {
  void addHeaders(HttpRequest request, Map<String, String> headers) {
    for (var header in headers.entries) {
      request.headers.add(header.key, header.value);
    }
  }

  void addCookies(HttpRequest request, List<Cookie> cookies) {
    request.response.cookies.addAll(cookies);
  }
}

class XwwwFormUrlEncodedResponse extends Response
    with ResponseConstructorMixin {
  final List<Cookie> cookies = [];
  final Map<String, String> data;
  final Map<String, String> headers = {};

  XwwwFormUrlEncodedResponse(Map<String, String> data) : this.data = data;

  @override
  Future<void> constructResponse(HttpRequest request) async {
    request.response.headers.contentType =
        ContentType("application", "x-www-urlencoded");
    addHeaders(request, headers);
    addCookies(request, cookies);
    String body = "";
    data.forEach((key, value) {
      body += HtmlEscape().convert(key) + "=" + HtmlEscape().convert(value);
    });
    request.response.write(body);
  }
}

class JsonResponse extends Response with ResponseConstructorMixin {
  List<Cookie> cookies = [];
  Map<String, String> headers = {};
  late Map data;

  JsonResponse(Object data) {
    data = jsonEncode(data);
  }

  @override
  Future<void> constructResponse(HttpRequest request) async {
    request.response.headers.contentType = ContentType.json;
    addHeaders(request, headers);
    addCookies(request, cookies);
    request.response.write(data);
  }
}

class FormDataResponse extends Response with ResponseConstructorMixin {
  final Map<String, dynamic> data;
  final List<Cookie> cookies = [];
  final Map<String, String> headers = {};

  FormDataResponse(Map<String, dynamic> data) : this.data = data;

  @override
  Future<void> constructResponse(HttpRequest request) async {
    request.response.headers.contentType =
        ContentType("multipart", "form-data");
    final String boundary = "------featherApiBoundary" + await nanoid(15);
    request.response.headers.add("boundary", boundary);

    data.forEach((key, value) async {
      request.response.writeln();
      request.response.writeln(boundary);
      request.response.writeln("Content-Disposition: form-data; name=\"$key\"");
      request.response.writeln();

      if (value is MultipartFile) {
        await for (final data in value.stream) {
          request.response.write(data);
        }
      }
    });
    request.response.writeln(boundary + "--");
  }
}
