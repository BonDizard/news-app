import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../../core/common_widgets/loader.dart';
import '../../../../models/news_channel_headline_model.dart';
import '../news_details_screen.dart';

class NewsArticleCard extends StatelessWidget {
  final Articles article;

  const NewsArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;

    // Calculate the time difference
    final DateTime publishedDate = DateTime.parse(article.publishedAt);
    final Duration difference = DateTime.now().difference(publishedDate);
    final String formattedDate = _formatDifference(difference);

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
                    Text(
                      article.title.toString(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
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

  // Function to format the time difference
  String _formatDifference(Duration difference) {
    if (difference.inDays > 1) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays == 1) {
      return '1 day ago';
    } else if (difference.inHours > 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours == 1) {
      return '1 hour ago';
    } else if (difference.inMinutes > 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes == 1) {
      return '1 minute ago';
    } else {
      return 'Just now';
    }
  }
}
