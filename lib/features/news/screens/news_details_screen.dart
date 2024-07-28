import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pingo_learn_news_app/core/utils/snack_bar.dart';
import 'package:pingo_learn_news_app/features/auth/screens/widgets/reusable_button.dart';
import 'package:pingo_learn_news_app/models/news_channel_headline_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/common_widgets/loader.dart';
import '../../../core/common_widgets/reusable_app_bar.dart';

class NewsDetailsPage extends StatelessWidget {
  final Articles article;
  const NewsDetailsPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // Format the publishedAt timestamp
    final DateFormat formatter = DateFormat('dd MMM yyyy, hh:mm a');
    final String formattedDate =
        formatter.format(DateTime.parse(article.publishedAt));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: ReusableAppBar(
        height: height * 0.07,
        leading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'News Details',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 16.0),
            Container(
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage.toString(),
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Loader(),
                  errorWidget: (context, url, error) => Center(
                    child: Image.asset(
                      'assets/breaking_news.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              article.title.toString(),
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.content.toString() == 'null'
                          ? 'No content to show'
                          : article.content.toString(),
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Source: ${article.source!.name.toString()}',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                        ),
                        Text(
                          formattedDate,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ReusableButton(
                  onButtonPressed: () async {
                    final Uri url = Uri.parse(article.url.toString());
                    try {
                      await launchUrl(url);
                    } catch (e) {
                      if (kDebugMode) {
                        print('Error in url launcher: ${e.toString()}');
                      }
                      showSnackBar(context: context, text: 'Could not launch');
                    }
                  },
                  buttonText: 'Read Full Article',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
