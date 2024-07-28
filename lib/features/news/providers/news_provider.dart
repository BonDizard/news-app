import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pingo_learn_news_app/features/news/controller/news_view_model.dart';
import '../../../models/news_channel_headline_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsProvider with ChangeNotifier {
  NewsChannelHeadlinesModel? _newsChannelHeadlines;
  String _selectedCountry = 'in'; // Default country is 'in'
  bool _isCached = false;

  final _newsStreamController =
      StreamController<NewsChannelHeadlinesModel?>.broadcast();

  String get selectedCountry => _selectedCountry;
  NewsChannelHeadlinesModel? get newsChannelHeadlines => _newsChannelHeadlines;
  bool get isCached => _isCached;

  Stream<NewsChannelHeadlinesModel?> get newsStream =>
      _newsStreamController.stream;

  final _newsViewModel = NewsViewModel();

  void setSelectedCountry(String country, BuildContext context) {
    _selectedCountry = country;
    fetchNews(context);
  }

  Future<void> fetchNews(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedNews = prefs.getString('news_$_selectedCountry');

    if (cachedNews != null) {
      _newsChannelHeadlines =
          NewsChannelHeadlinesModel.fromJson(jsonDecode(cachedNews));
      _newsStreamController.sink.add(_newsChannelHeadlines);
    } else {
      _newsViewModel.fetchNewsChannelHeadlineApi(context: context);
    }

    notifyListeners();
  }

  void setNewsChannelHeadlines(NewsChannelHeadlinesModel newsChannelHeadlines,
      {bool isCached = false}) async {
    _newsChannelHeadlines = newsChannelHeadlines;
    _isCached = isCached;
    _newsStreamController.sink.add(_newsChannelHeadlines);

    if (!isCached) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
          'news_$_selectedCountry', jsonEncode(newsChannelHeadlines.toJson()));
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _newsStreamController.close();
    super.dispose();
  }
}
