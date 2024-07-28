import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pingo_learn_news_app/core/common/error_text.dart';
import 'package:pingo_learn_news_app/core/common/loader.dart';
import 'package:pingo_learn_news_app/features/news/screens/widgets/news_article_card.dart';
import '../../../models/news_channel_headline_model.dart';
import '../controller/news_view_model.dart';
import '../providers/news_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

const Map<String, String> countries = {
  'USA': 'us',
  'India': 'in',
  'Korea': 'kr',
  'China': 'cn'
};

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() {
    print('NewsScreen createState called');
    return _NewsScreenState();
  }
}

class _NewsScreenState extends State<NewsScreen> {
  final _newsViewModel = NewsViewModel();

  @override
  void initState() {
    print('initState called');
    super.initState();
    print('super.initState called');
    _newsViewModel.fetchNewsChannelHeadlineApi(context: context);
    print('fetchNewsChannelHeadlineApi called');
  }

  @override
  Widget build(BuildContext context) {
    print('build called');
    final height = MediaQuery.of(context).size.height;
    final selectedCountry = Provider.of<NewsProvider>(context).selectedCountry;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        toolbarHeight: height * 0.07,
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
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    print('onPressed called');
                    _showCountryPicker(context);
                  },
                  icon: Icon(
                    CupertinoIcons.location_fill,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                Text(
                  selectedCountry.toUpperCase(),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Theme.of(context).colorScheme.surface,
                      ),
                )
              ],
            ),
          ),
        ],
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
          Expanded(
            child: StreamBuilder<NewsChannelHeadlinesModel?>(
              stream: Provider.of<NewsProvider>(context).newsStream,
              builder: (context, snapshot) {
                print("StreamBuilder builder called");
                if (snapshot.connectionState == ConnectionState.waiting) {
                  print("ConnectionState.waiting");
                  return Center(child: Loader());
                } else if (snapshot.hasError) {
                  print("snapshot.hasError");
                  return ErrorText(error: 'Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  print("snapshot.hasData");
                  final news = snapshot.data;
                  print("news: $news");

                  if (news == null) {
                    print("news is null");
                    return ErrorText(error: 'No news available');
                  } else {
                    final isCached =
                        Provider.of<NewsProvider>(context).isCached;
                    return Column(
                      children: [
                        if (isCached)
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'You are viewing cached data due to rate limiting.',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: news.articles.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              print("itemBuilder called");
                              final article = news.articles[index];
                              print("article: $article");
                              final formattedDate = DateFormat('dd MMM yyyy')
                                  .format(DateTime.parse(
                                      article.publishedAt ?? ''));
                              print("formattedDate: $formattedDate");
                              return NewsArticleCard(
                                  article: article,
                                  formattedDate: formattedDate);
                            },
                          ),
                        ),
                      ],
                    );
                  }
                } else {
                  print("No data and no error");
                  return ErrorText(error: 'No data available');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showCountryPicker(BuildContext context) {
    print('_showCountryPicker called');
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        print('showModalBottomSheet called');
        return Container(
          height: 230,
          child: ListView.builder(
            itemCount: countries.length,
            itemBuilder: (context, index) {
              print('ListView.builder called');
              final countryCode = countries.values.elementAt(index);
              final countryName = countries.keys.elementAt(index);
              final selectedCountry =
                  Provider.of<NewsProvider>(context, listen: false)
                      .selectedCountry;
              final isSelected = countryCode == selectedCountry;

              return ListTile(
                title: Text(
                  countryName,
                  style: isSelected
                      ? Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary)
                      : Theme.of(context).textTheme.displayMedium,
                ),
                onTap: () {
                  print('onTap called');
                  Provider.of<NewsProvider>(context, listen: false)
                      .setSelectedCountry(countryCode, context);
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }
}
