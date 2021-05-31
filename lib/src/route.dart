enum HttpMethod { GET, POST, PATCH, PUT, DELETE, OPTIONS }

class CompiledRoute {
  final Pattern match;
  final HttpMethod method;

  CompiledRoute({required this.match, required this.method});
  bool resolves(String url) {
    return true; //TODO
  }
}
