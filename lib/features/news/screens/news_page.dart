import 'package:flutter/material.dart';
import 'package:pingo_learn_news_app/core/common/error_text.dart';
import 'package:pingo_learn_news_app/core/common/loader.dart';
import '../controller/news_view_model.dart';
import '../repository/news_provider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class NewsScreen extends StatelessWidget {
  final NewsViewModel _newsViewModel = NewsViewModel();

  NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('Building NewsScreen widget...');
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('News'),
      ),
      body: FutureBuilder<void>(
        future: _newsViewModel.fetchNewsChannelHeadlineApi(context: context),
        builder: (context, snapshot) {
          print('FutureBuilder: connectionState = ${snapshot.connectionState}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('FutureBuilder: Waiting for data...');
            return Center(
                child:
                    CircularProgressIndicator()); // <--- Use a loading indicator
          } else if (snapshot.hasError) {
            print('FutureBuilder: Error = ${snapshot.error}');
            return ErrorText(error: 'Error: ${snapshot.error}');
          } else {
            print('FutureBuilder: Data fetched successfully');
            final newsProvider = Provider.of<NewsProvider>(context);
            final news = newsProvider.newsChannelHeadlines;
            if (news == null) {
              return ErrorText(error: 'No news available');
            } else {
              return ListView.builder(
                itemCount: news.articles.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final article = news.articles[index];
                  final formattedDate = DateFormat('dd MMM yyyy')
                      .format(DateTime.parse(article.publishedAt ?? ''));
                  return SizedBox(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                            height: height * 0.6,
                            width: width * .9,
                            padding:
                                EdgeInsets.symmetric(horizontal: height * .02),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: article.urlToImage != null &&
                                      article.urlToImage!.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: article.urlToImage.toString(),
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        child: Loader(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                      ),
                                    )
                                  : Center(
                                      child: Text('No image to preview'),
                                    ),
                            )),
                        Positioned(
                          bottom: 20,
                          child: Card(
                            elevation: 5,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              alignment: Alignment.bottomCenter,
                              padding: EdgeInsets.all(15),
                              height: height * .22,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      width: width * 0.7,
                                      child: Text(article.title.toString(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis)),
                                  Spacer(),
                                  Container(
                                    width: width * 0.7,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          article.source!.name.toString(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          formattedDate,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
