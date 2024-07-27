import 'dart:async';
import 'package:flutter/material.dart';
import '../../../models/news_channel_headline_model.dart';

class NewsProvider with ChangeNotifier {
  NewsChannelHeadlinesModel? _newsChannelHeadlines;

  final _newsStreamController =
      StreamController<NewsChannelHeadlinesModel?>.broadcast();

  NewsChannelHeadlinesModel? get newsChannelHeadlines => _newsChannelHeadlines;

  Stream<NewsChannelHeadlinesModel?> get newsStream =>
      _newsStreamController.stream;

  void setNewsChannelHeadlines(NewsChannelHeadlinesModel newsChannelHeadlines) {
    _newsChannelHeadlines = newsChannelHeadlines;
    _newsStreamController.sink.add(_newsChannelHeadlines);
    print('Stream updated with news data');
    notifyListeners();
  }

  @override
  void dispose() {
    _newsStreamController.close();
    super.dispose();
  }
}
