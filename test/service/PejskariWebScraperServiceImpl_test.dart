import 'package:flutter_test/flutter_test.dart';
import 'package:pejskari/data/Article.dart';
import 'package:pejskari/service/ArticlesWebScraperService.dart';
import 'package:pejskari/service/PejskariWebScraperServiceImpl.dart';

Future<void> main() async {
  test('Get articles', () async {
    //GIVEN
    ArticlesWebScraperService tested = PejskariWebScraperServiceImpl("Pejskaři", "https://www.pejskari.cz/");
    //WHEN
    var articles = await tested.getArticles();
    //THEN
    assert(articles.length >= 17); //aktualne je na webu 17 clanku
    expect(articles.last, Article("Pejskaři", "Coursing", "11.06.2020", "https://www.pejskari.cz//clanky/psi-aktivity/coursing"));
  });
  }