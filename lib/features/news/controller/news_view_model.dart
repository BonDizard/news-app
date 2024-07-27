import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:pingo_learn_news_app/features/news/repository/news_repository.dart';
import '../../../core/utils/snack_bar.dart';
import '../repository/news_provider.dart';

class NewsViewModel {
  final _newsRepository = NewsRepository();

  Future<void> fetchNewsChannelHeadlineApi(
      {required BuildContext context}) async {
    try {
      final res = await _newsRepository.fetchNewsChannelHeadlineApi().timeout(
            const Duration(seconds: 10),
          );
      res.fold(
        (failure) => showSnackBar(
          context: context,
          text: failure.toString(),
        ),
        (newsChannelHeadlinesModel) {
          print('Fetched news data: ${newsChannelHeadlinesModel.toJson()}');
          Provider.of<NewsProvider>(context, listen: false)
              .setNewsChannelHeadlines(newsChannelHeadlinesModel);
          Provider.of<NewsProvider>(context, listen: false).notifyListeners();
        },
      );
    } catch (e) {
      showSnackBar(
          context: context, text: 'Error in view model: ${e.toString()}');
    }
  }
}
