enum HttpMethod { GET, POST, PATCH, PUT, DELETE, OPTIONS }

class CompiledRoute {
  final Pattern match;
  final HttpMethod method;

  CompiledRoute({required this.match, required this.method});

  Map<String, dynamic>? resolves(String url) {
    if (match is String) {
      return {};
    }
    url = url.replaceFirst(RegExp("^[A-Z]* "), "");
    final m = (match as RegExp).firstMatch(url);
    if (m != null && m.group(0) == url) {
      return Map.fromEntries(m.groupNames.map<MapEntry<String, dynamic>>((e) {
        return MapEntry(e, m.namedGroup(e));
      }));
    }
  }
}
