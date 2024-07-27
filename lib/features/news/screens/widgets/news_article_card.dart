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
      margin: EdgeInsets.all(10),
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
          padding: EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: width * 0.3,
                height: height * 0.15,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: article.urlToImage != null &&
                          article.urlToImage!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: article.urlToImage.toString(),
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            child: Loader(),
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.error_outline,
                            color: Colors.red,
                          ),
                        )
                      : Center(
                          child: Text('No image to preview'),
                        ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title.toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      article.source!.name.toString(),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    SizedBox(height: 4),
                    Text(
                      formattedDate,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
