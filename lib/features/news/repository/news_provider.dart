import 'dart:async';
import 'package:flutter/material.dart';
import '../../../models/news_channel_headline_model.dart';

class NewsProvider with ChangeNotifier {
  NewsChannelHeadlinesModel? _newsChannelHeadlines;
  String _selectedCountry = 'in';

  final _newsStreamController =
      StreamController<NewsChannelHeadlinesModel?>.broadcast();

  String get selectedCountry => _selectedCountry;

  NewsChannelHeadlinesModel? get newsChannelHeadlines => _newsChannelHeadlines;

  Stream<NewsChannelHeadlinesModel?> get newsStream =>
      _newsStreamController.stream;

  void setSelectedCountry(String country) {
    _selectedCountry = country;
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
