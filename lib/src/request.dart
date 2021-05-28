import 'dart:io';

abstract class BaseRequest {
  final HttpHeaders headers;
  final List<Cookie> cookies;
  final int contentLength;
  final Uri requestUri;
  final Map<String, String> query;
  final String method;
  final HttpRequest rawRequest;
  final HttpSession session;
  abstract final dynamic body;

  BaseRequest(HttpRequest request)
      : this.headers = request.headers,
        this.cookies = request.cookies,
        this.contentLength = request.contentLength,
        this.requestUri = request.requestedUri,
        this.method = request.method,
        this.query = request.requestedUri.queryParameters,
        this.session = request.session,
        this.rawRequest = request;
}

class GetRequest extends BaseRequest {
  GetRequest(HttpRequest request) : super(request);
  @override
  dynamic get body => throw Exception("Body not applicable for GET verb");
}

class PostRequest extends BaseRequest {
  PostRequest(HttpRequest request) : super(request) {
    request.listen((event) {});
  }

  @override
  // TODO: implement body
  get body => throw UnimplementedError();
}
