import 'package:featherApi/src/url_resolver.dart';

class ControllerOf {
  final UrlResolver resolver;
  const ControllerOf(this.resolver);
}

abstract class Method {
  abstract final String method;
  const Method();
}

class Post extends Method {
  final UrlResolver resolver;
  @override
  final String method = "POST";
  const Post(this.resolver);
}

class Get extends Method {
  final UrlResolver resolver;
  @override
  final String method = "GET";
  const Get(this.resolver);
}

class Patch extends Method {
  final UrlResolver resolver;
  @override
  final String method = "PATCH";
  const Patch(this.resolver);
}

class Put extends Method {
  final UrlResolver resolver;
  @override
  final String method = "PUT";
  const Put(this.resolver);
}
