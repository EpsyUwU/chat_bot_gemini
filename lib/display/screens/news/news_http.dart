import 'package:flutter/material.dart';
import 'package:flutter_challenges/core/providers/nyt_providers_http.dart';
import 'package:flutter_challenges/display/screens/news/news_page.dart';
import 'package:flutter_challenges/display/widgets/news/news_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewsHttp extends ConsumerWidget {
  const NewsHttp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsData = ref.watch(nytNewsProviderHttp);

    return Stack(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(bottom: 15, left: 12, right: 12, top: 15),
          child: newsData.when(
            data: (news) {
              return Expanded(
                child: ListView.builder(
                  itemCount: news.results.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            NewsPage.route(
                              title: "Flutter prueba",
                              url: news.results.elementAt(index).url,
                            ));
                      },
                      child: NewsCard(
                          image: news.results
                              .elementAt(index)
                              .media
                              .first
                              .mediaMetadata
                              .elementAt(2)
                              .url,
                          title: news.results.elementAt(index).title),
                    );
                  },
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stackTrace) => const Center(
              child: Text('Error al cargar noticias'),
            ),
          ),
        ),
      ],
    );
  }
}
