import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pingo_learn_news_app/core/common/error_text.dart';
import 'package:pingo_learn_news_app/core/common/loader.dart';
import 'package:pingo_learn_news_app/features/news/screens/widgets/news_article_card.dart';
import '../../../models/news_channel_headline_model.dart';
import '../controller/news_view_model.dart';
import '../repository/news_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final _newsViewModel = NewsViewModel();

  @override
  void initState() {
    super.initState();
    _newsViewModel.fetchNewsChannelHeadlineApi(context: context);
  }

  void _showCountryPicker(BuildContext context) {
    print("_showCountryPicker called");
    final countryList = [
      'ae',
      'ar',
      'at',
      'au',
      'be',
      'bg',
      'br',
      'ca',
      'ch',
      'cn',
      'co',
      'cu',
      'cz',
      'de',
      'eg',
      'fr',
      'gb',
      'gr',
      'hk',
      'hu',
      'id',
      'ie',
      'il',
      'in',
      'it',
      'jp',
      'kr',
      'lt',
      'lv',
      'ma',
      'mx',
      'my',
      'ng',
      'nl',
      'no',
      'nz',
      'ph',
      'pl',
      'pt',
      'ro',
      'ru',
      'sa',
      'se',
      'sg',
      'si',
      'sk',
      'th',
      'tr',
      'tw',
      'ua',
      'us',
      've',
      'za',
    ];
    print("countryList: $countryList");
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        print("showModalBottomSheet called");
        return Container(
          height: 300,
          child: ListView.builder(
            itemCount: countryList.length,
            itemBuilder: (context, index) {
              print("itemBuilder called");
              final countryCode = countryList[index];
              print("countryCode: $countryCode");
              return ListTile(
                title: Text(countryCode),
                onTap: () {
                  print("onTap called");
                  Provider.of<NewsProvider>(context, listen: false)
                      .setSelectedCountry(countryCode, context);
                  print("setSelectedCountry called");
                  Navigator.pop(context);
                  print("Navigator.pop called");
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("build called");
    final width = MediaQuery.sizeOf(context).width * 1;
    print("width: $width");
    final height = MediaQuery.sizeOf(context).height * 1;
    print("height: $height");

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        toolbarHeight: height * .07,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'MyNews',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Theme.of(context).colorScheme.surface,
              ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: width * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    print("onPressed called");
                    _showCountryPicker(context);
                  },
                  icon: Icon(
                    CupertinoIcons.location_fill,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                Text(
                  'IN',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Theme.of(context).colorScheme.surface,
                      ),
                )
              ],
            ),
          ),
        ], // Set app bar title color
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(height * 0.015),
              child: Text(
                'Top Headlines',
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
          ),
          SizedBox(
            height: height * .82,
            child: StreamBuilder<NewsChannelHeadlinesModel?>(
              stream: Provider.of<NewsProvider>(context).newsStream,
              builder: (context, snapshot) {
                print("StreamBuilder builder called");
                if (snapshot.connectionState == ConnectionState.waiting) {
                  print("ConnectionState.waiting");
                  return Center(
                      child: Loader()); // <--- Use a loading indicator
                } else if (snapshot.hasError) {
                  print("snapshot.hasError");
                  return ErrorText(error: 'Error: ${snapshot.error}');
                } else {
                  print("snapshot.hasData");
                  final news = snapshot.data;
                  print("news: $news");

                  if (news == null) {
                    print("news is null");
                    return ErrorText(error: 'No news available');
                  } else {
                    print("news is not null");
                    return ListView.builder(
                      itemCount: news.articles.length,
                      scrollDirection:
                          Axis.vertical, // Changed to vertical scrolling
                      itemBuilder: (context, index) {
                        print("itemBuilder called");
                        final article = news.articles[index];
                        print("article: $article");
                        final formattedDate = DateFormat('dd MMM yyyy')
                            .format(DateTime.parse(article.publishedAt ?? ''));
                        print("formattedDate: $formattedDate");
                        return NewsArticleCard(
                            article: article, formattedDate: formattedDate);
                      },
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
