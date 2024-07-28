import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pingo_learn_news_app/core/constants/constants.dart';
import 'package:pingo_learn_news_app/features/news/screens/widgets/news_article_card.dart';
import '../../../core/common_widgets/loader.dart';
import '../../../core/common_widgets/reusable_app_bar.dart';
import '../../../core/error/error_text.dart';
import '../../../models/news_channel_headline_model.dart';
import '../controller/news_view_model.dart';
import '../providers/news_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() {
    return _NewsScreenState();
  }
}

class _NewsScreenState extends State<NewsScreen> {
  final _newsViewModel = NewsViewModel();

  @override
  void initState() {
    super.initState();
    _newsViewModel.fetchNewsChannelHeadlineApi(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final selectedCountry = Provider.of<NewsProvider>(context).selectedCountry;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: ReusableAppBar(
        height: height * 0.07,
        actionWidget: Padding(
          padding:
              EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.03),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Loader());
                } else if (snapshot.hasError) {
                  return ErrorText(error: 'Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final news = snapshot.data;

                  if (news == null) {
                    return const ErrorText(error: 'No news available');
                  } else {
                    final isCached =
                        Provider.of<NewsProvider>(context).isCached;
                    return Column(
                      children: [
                        if (isCached)
                          const Padding(
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
                              if (kDebugMode) {
                                print("itemBuilder called");
                              }
                              final article = news.articles[index];
                              if (kDebugMode) {
                                print("article: $article");
                              }

                              return NewsArticleCard(
                                article: article,
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                } else {
                  return const ErrorText(error: 'No data available');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showCountryPicker(BuildContext context) {
    if (kDebugMode) {
      print('_showCountryPicker called');
    }
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        if (kDebugMode) {
          print('showModalBottomSheet called');
        }
        return SizedBox(
          height: 230,
          child: ListView.builder(
            itemCount: Constant.countries.length,
            itemBuilder: (context, index) {
              final countryCode = Constant.countries.values.elementAt(index);
              final countryName = Constant.countries.keys.elementAt(index);
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
                  if (kDebugMode) {
                    print('onTap called');
                  }
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
