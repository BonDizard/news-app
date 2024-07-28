import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pingo_learn_news_app/features/news/repository/news_repository.dart';
import '../../../core/utils/snack_bar.dart';
import '../../../models/news_channel_headline_model.dart';
import '../providers/news_provider.dart';

class NewsViewModel {
  final _newsRepository = NewsRepository();

  Future<void> fetchNewsChannelHeadlineApi(
      {required BuildContext context}) async {
    try {
      final newsProvider = Provider.of<NewsProvider>(context, listen: false);
      final selectedCountry = newsProvider.selectedCountry;
      final res = await _newsRepository
          .fetchNewsChannelHeadlineApi(selectedCountry)
          .timeout(const Duration(seconds: 10));

      res.fold(
        (failure) async {
          print('Error: $failure');

          // If rate limited, fallback to cached data
          if (failure.message.contains('rateLimited')) {
            final prefs = await SharedPreferences.getInstance();
            final cachedNews = prefs.getString('news_$selectedCountry');

            if (cachedNews != null) {
              final newsChannelHeadlines =
                  NewsChannelHeadlinesModel.fromJson(jsonDecode(cachedNews));
              newsProvider.setNewsChannelHeadlines(newsChannelHeadlines,
                  isCached: true);
            } else {
              showSnackBar(
                  context: context,
                  text: 'Rate limit exceeded and no cached data available.');
            }
          } else {
            showSnackBar(
                context: context,
                text: 'Error in view model: ${failure.message}');
          }
        },
        (newsChannelHeadlinesModel) {
          newsProvider.setNewsChannelHeadlines(newsChannelHeadlinesModel);
        },
      );
    } catch (e) {
      print('Error in view model: ${e.toString()}');
      showSnackBar(
          context: context, text: 'Unexpected error occurred: ${e.toString()}');
    }
  }
}
