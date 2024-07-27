import 'package:flutter/material.dart';
import 'package:pingo_learn_news_app/core/common/error_text.dart';
import 'package:pingo_learn_news_app/core/common/loader.dart';
import 'package:pingo_learn_news_app/features/news/screens/widgets/news_article_card.dart';
import '../../../models/news_channel_headline_model.dart';
import '../controller/news_view_model.dart';
import '../repository/news_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class NewsScreen extends StatelessWidget {
  final NewsViewModel _newsViewModel = NewsViewModel();

  NewsScreen({super.key});

  void _showCountryPicker(BuildContext context) {
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
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          child: ListView.builder(
            itemCount: countryList.length,
            itemBuilder: (context, index) {
              final countryCode = countryList[index];
              return ListTile(
                title: Text(countryCode),
                onTap: () {
                  Provider.of<NewsProvider>(context, listen: false)
                      .setSelectedCountry(countryCode);
                  _newsViewModel.fetchNewsChannelHeadlineApi(context: context);
                  Navigator.pop(context);
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
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue, // Set app bar background color
        title: Text('MyNews', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              _showCountryPicker(context);
            },
            icon: Icon(Icons.location_on),
          ),
        ], // Set app bar title color
      ),
      body: StreamBuilder<NewsChannelHeadlinesModel?>(
        stream: Provider.of<NewsProvider>(context).newsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Loader()); // <--- Use a loading indicator
          } else if (snapshot.hasError) {
            return ErrorText(error: 'Error: ${snapshot.error}');
          } else {
            final news = snapshot.data;

            if (news == null) {
              return ErrorText(error: 'No news available');
            } else {
              return ListView.builder(
                itemCount: news.articles.length,
                scrollDirection: Axis.vertical, // Changed to vertical scrolling
                itemBuilder: (context, index) {
                  final article = news.articles[index];
                  final formattedDate = DateFormat('dd MMM yyyy')
                      .format(DateTime.parse(article.publishedAt ?? ''));
                  return NewsArticleCard(
                      article: article, formattedDate: formattedDate);
                },
              );
            }
          }
        },
      ),
    );
  }
}
