import 'dart:html';

class UrlResolver {
  final Pattern targetPattern;

  UrlResolver({required this.targetPattern});

  bool resolve(Pattern url) {
    return this.targetPattern == url;
  }

  @override
  bool operator ==(Object other) {
    if (other is UrlResolver) {
      return other.resolve(this.targetPattern);
    } else if (other is String) {
      return this.resolve(other);
    }

    return false;
  }

  @override
  UrlResolver operator +(UrlResolver other) {
    return UrlResolver(targetPattern: "$targetPattern${other.targetPattern}");
  }
}
