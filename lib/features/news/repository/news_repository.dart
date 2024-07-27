import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:pingo_learn_news_app/core/error/failure.dart';
import 'package:pingo_learn_news_app/core/utils/type_defs.dart';
import 'package:pingo_learn_news_app/models/news_channel_headline_model.dart';
import '../../../core/constants/api_constant.dart';
import 'package:http/http.dart' as http;

class NewsRepository {
  FutureEither<NewsChannelHeadlinesModel> fetchNewsChannelHeadlineApi() async {
    try {
      String url =
          'https://newsapi.org/v2/top-headlines?country=us&apiKey=${ApiConstant.apiKey}';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return right(NewsChannelHeadlinesModel.fromJson(body));
      } else {
        throw Exception('Error');
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
