import 'package:flutter/material.dart';
import 'package:pejskari/NavigationDrawer.dart';
import 'package:pejskari/data/Article.dart';
import 'package:pejskari/pages/Articles/ArticleWebViewPage.dart';
import 'package:pejskari/service/ArticlesWebScraperService.dart';
import 'package:pejskari/service/PejskariWebScraperServiceImpl.dart';

/// This class represents page with articles.
class ArticlesPage extends StatefulWidget {
  static const String routeName = "/articles";

  const ArticlesPage({Key? key}) : super(key: key);

  @override
  _ArticlesPageState createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  final ArticlesWebScraperService _pejskariWebScraper =
      PejskariWebScraperServiceImpl("Pejskaři", "https://www.pejskari.cz");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Články"),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    content: const Text(
                        "Tato funkcionalita potřebuje internetové připojení."),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Rozumím'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.info_outline))
        ],
      ),
      drawer: const NavigationDrawer(),
      body: FutureBuilder(
          future: _pejskariWebScraper.getArticles(),
          builder: (context, AsyncSnapshot<List<Article>> snapshot) {
            if (snapshot.hasError) {
              return Wrap(children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                )
              ]);
            }
            if (snapshot.hasData) {
              return ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.article),
                    title: Text(snapshot.data![index].title),
                    subtitle: Text(snapshot.data![index].webName +
                        " Publikováno " +
                        snapshot.data![index].dateTime),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [],
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ArticleWebViewPage(
                              title: snapshot.data![index].title,
                              url: snapshot.data![index].url)));
                    },
                  );
                },
                separatorBuilder: (buildContext, index) {
                  return const Divider(height: 1);
                },
                itemCount: snapshot.data!.length,
                shrinkWrap: true,
                padding: const EdgeInsets.all(5),
                scrollDirection: Axis.vertical,
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
