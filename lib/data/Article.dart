class Article {
  final String webName;
  final String title;
  final String dateTime;
  final String url;

  Article(this.webName, this.title, this.dateTime, this.url);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Article &&
          runtimeType == other.runtimeType &&
          webName == other.webName &&
          title == other.title &&
          dateTime == other.dateTime &&
          url == other.url;

  @override
  int get hashCode =>
      webName.hashCode ^ title.hashCode ^ dateTime.hashCode ^ url.hashCode;
}