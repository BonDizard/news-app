import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pingo_learn_news_app/features/news/controller/news_view_model.dart';
import '../../../models/news_channel_headline_model.dart';

class NewsProvider with ChangeNotifier {
  NewsChannelHeadlinesModel? _newsChannelHeadlines;
  String _selectedCountry = 'in'; // Default country is 'in'

  final _newsStreamController =
      StreamController<NewsChannelHeadlinesModel?>.broadcast();

  String get selectedCountry => _selectedCountry;

  NewsChannelHeadlinesModel? get newsChannelHeadlines => _newsChannelHeadlines;

  Stream<NewsChannelHeadlinesModel?> get newsStream =>
      _newsStreamController.stream;
  final _newsViewModel = NewsViewModel();

  void setSelectedCountry(String country, BuildContext context) {
    _selectedCountry = country;
    _newsViewModel.fetchNewsChannelHeadlineApi(context: context);
    notifyListeners();
  }

  void setNewsChannelHeadlines(NewsChannelHeadlinesModel newsChannelHeadlines) {
    _newsChannelHeadlines = newsChannelHeadlines;
    _newsStreamController.sink.add(_newsChannelHeadlines);
    notifyListeners();
  }

  @override
  void dispose() {
    _newsStreamController.close();
    super.dispose();
  }
}
