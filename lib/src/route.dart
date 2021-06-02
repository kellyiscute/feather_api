enum HttpMethod { GET, POST, PATCH, PUT, DELETE, OPTIONS }

class CompiledRoute {
  final RegExp match;
  final HttpMethod method;

  CompiledRoute({required this.match, required this.method});
  Map<String, dynamic>? resolves(String url) {
    var matches = match.allMatches(url);
    if (matches.isNotEmpty) {
      var m = matches.first;
      return Map.fromEntries(m.groupNames.map<MapEntry<String, dynamic>>((e) {
        return MapEntry(e, m.namedGroup(e));
      }));
    }
  }
}
