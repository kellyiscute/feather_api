import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

import 'package:html_unescape/html_unescape.dart';
import 'package:multipart/multipart.dart';

abstract class BaseRequest {
  final HttpHeaders headers;
  final List<Cookie> cookies;
  final int contentLength;
  final Uri requestUri;
  final Map<String, String> query;
  final String method;
  final HttpRequest rawRequest;
  final HttpSession session;
  final Map<String, dynamic> urlParams;
  abstract final dynamic body;

  BaseRequest(HttpRequest request, {Map<String, dynamic>? urlParams})
      : this.headers = request.headers,
        this.cookies = request.cookies,
        this.contentLength = request.contentLength,
        this.requestUri = request.requestedUri,
        this.method = request.method,
        this.query = request.requestedUri.queryParameters,
        this.session = request.session,
        this.rawRequest = request,
        this.urlParams = urlParams ?? {};
}

class ParsedRequest extends BaseRequest {
  ParsedRequest(HttpRequest request, {Map<String, dynamic>? urlParams})
      : super(request, urlParams: urlParams);

  dynamic _body;
  final Uint8List _rawBody = Uint8List(0);

  Future<void> parse() async {
    final contentType = rawRequest.headers.contentType;

    // handle multipart
    if (contentType?.value == "multipart/form-data") {
      _body = await Multipart(rawRequest).load();
      return;
    }

    // load all data if not multipart
    await for (final data in rawRequest) {
      _rawBody.addAll(data);
    }

    if (contentType == ContentType.json) {
      _body = jsonDecode(Utf8Decoder().convert(_rawBody));
    } else if (contentType?.value == "application/x-www-urlencoded") {
      _body = Utf8Decoder().convert(_rawBody);
      final splitted = (_body as String).split("&");
      _body = Map.fromEntries(splitted.map((e) {
        final keyValue = e.split("=");
        return MapEntry(HtmlUnescape().convert(keyValue[0]),
            HtmlUnescape().convert(keyValue[1]));
      }));
    } else if (contentType == ContentType.text) {
      _body = Utf8Decoder().convert(_rawBody);
    }
  }

  @override
  get body => _body;
}
