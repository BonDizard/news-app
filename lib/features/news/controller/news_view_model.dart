import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pingo_learn_news_app/features/news/repository/news_repository.dart';
import '../../../core/utils/snack_bar.dart';
import '../repository/news_provider.dart';

class NewsViewModel {
  final _newsRepository = NewsRepository();
  Future<void> fetchNewsChannelHeadlineApi(
      {required BuildContext context}) async {
    try {
      final newsProvider = Provider.of<NewsProvider>(context, listen: false);
      final selectedCountry = newsProvider.selectedCountry;

      final res = await _newsRepository
          .fetchNewsChannelHeadlineApi(selectedCountry)
          .timeout(
            const Duration(seconds: 10),
          );
      res.fold(
        (failure) {
          print(failure);
        },
        (newsChannelHeadlinesModel) {
          Provider.of<NewsProvider>(context, listen: false)
              .setNewsChannelHeadlines(newsChannelHeadlinesModel);
          Provider.of<NewsProvider>(context, listen: false).notifyListeners();
        },
      );
    } catch (e) {
      if (ScaffoldMessenger.of(context).mounted) {
        showSnackBar(
          context: context,
          text: 'Error in view model: ${e.toString()}',
        );
      }
    }
  }
}
