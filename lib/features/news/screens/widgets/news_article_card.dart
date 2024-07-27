import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/common/loader.dart';
import '../../../../models/news_channel_headline_model.dart';
import '../news_details_screen.dart';

class NewsArticleCard extends StatelessWidget {
  final Articles article;
  final String formattedDate;

  const NewsArticleCard(
      {super.key, required this.article, required this.formattedDate});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;

    return Card(
      color: Colors.white,
      margin: EdgeInsets.all(height * 0.01),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDetailsPage(article: article),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(height * 0.015),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      article.source!.name.toString(),
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    SizedBox(height: height * .02),
                    Text(article.title.toString(),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.displayMedium),
                    SizedBox(height: height * .023),
                    Text(
                      formattedDate,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              SizedBox(width: width * 0.05),
              SizedBox(
                width: width * 0.3,
                height: height * 0.13,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: article.urlToImage != null &&
                          article.urlToImage!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: article.urlToImage.toString(),
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Loader(),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                          ),
                        )
                      : Image.asset(
                          'assets/breaking_news.jpg',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
