import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:pingo_learn_news_app/core/error/failure.dart';
import 'package:pingo_learn_news_app/core/utils/type_defs.dart';
import 'package:pingo_learn_news_app/models/news_channel_headline_model.dart';
import '../../../core/constants/constants.dart';
import 'package:http/http.dart' as http;

class NewsRepository {
  FutureEither<NewsChannelHeadlinesModel> fetchNewsChannelHeadlineApi(
      String selectedCountry) async {
    try {
      String url =
          'https://newsapi.org/v2/top-headlines?country=$selectedCountry&apiKey=${Constant.apiKey}';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return right(NewsChannelHeadlinesModel.fromJson(body));
      } else {
        throw Exception(
            'Error: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
