import 'package:pejskari/data/Article.dart';
import 'package:pejskari/service/ArticlesWebScraperService.dart';
import 'package:web_scraper/web_scraper.dart';

/// Service for scraping articles from Pejskari.cz.
class PejskariWebScraperServiceImpl extends ArticlesWebScraperService {
  PejskariWebScraperServiceImpl(webName, baseUrl) : super(webName, baseUrl);

  @override
  Future<List<Article>> getArticles() async {
    List<Article> articles = [];
    try {
      final webScraper = WebScraper(baseUrl);
      if (await webScraper.loadWebPage("/clanky")) {
        List<Map<String, dynamic>> articleTitles =
            webScraper.getElement('article > h2', []);
        List<Map<String, dynamic>> articleDates =
            webScraper.getElement('article > div > time', []);
        List<Map<String, dynamic>> articleUrls =
            webScraper.getElement('article > a', ["href"]);

        for (int i = 0; i < articleTitles.length; i++) {
          articles.add(Article(
              webName,
              articleTitles[i]["title"].toString(),
              articleDates[i]["title"].toString().replaceAll(" ", ""),
              baseUrl + articleUrls[i]["attributes"]["href"].toString()));
        }
      }
    } on WebScraperException catch (exception) {}
    return articles;
  }
}
