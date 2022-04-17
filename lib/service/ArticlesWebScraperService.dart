import 'package:pejskari/data/Article.dart';

/// Interface for services scraping articles.
abstract class ArticlesWebScraperService {
  final String webName;
  final String baseUrl;

  ArticlesWebScraperService(this.webName, this.baseUrl);

  Future<List<Article>> getArticles();
}