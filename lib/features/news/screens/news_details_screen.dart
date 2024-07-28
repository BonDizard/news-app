import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pingo_learn_news_app/core/common/loader.dart';
import 'package:pingo_learn_news_app/core/utils/snack_bar.dart';
import 'package:pingo_learn_news_app/features/auth/screens/widgets/reusable_button.dart';
import 'package:pingo_learn_news_app/models/news_channel_headline_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailsPage extends StatelessWidget {
  final Articles article;
  const NewsDetailsPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height * .07,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'MyNews',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Theme.of(context).colorScheme.surface,
              ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(height * 0.015),
                  child: Text(
                    'News Details',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
              ),
              SizedBox(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: height * 0.6,
                      width: width * .9,
                      padding: EdgeInsets.symmetric(horizontal: height * .02),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl: article.urlToImage.toString(),
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            child: Loader(),
                          ),
                          errorWidget: (context, url, error) => Center(
                            child: Image.asset(
                              'assets/breaking_news.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      child: Card(
                        elevation: 5,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          padding: EdgeInsets.all(15),
                          height: height * .22,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: width * 0.8,
                                child: Text(
                                  article.title.toString(),
                                  style:
                                      Theme.of(context).textTheme.displayLarge,
                                ),
                              ),
                              Text(
                                article.content.toString() == 'null'
                                    ? 'No content to show'
                                    : article.content.toString(),
                              ),
                              Spacer(),
                              Container(
                                width: width * 0.7,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      article.source!.name.toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      article.publishedAt.toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              ReusableButton(
                onButtonPressed: () async {
                  final Uri url = Uri.parse(article.url.toString());
                  try {
                    await launchUrl(url);
                  } catch (e) {
                    if (kDebugMode) {
                      print('Error in url laucher: ${e.toString()}');
                    }
                    showSnackBar(context: context, text: 'Could not launch');
                  }
                },
                buttonText: 'Read Full Article',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
