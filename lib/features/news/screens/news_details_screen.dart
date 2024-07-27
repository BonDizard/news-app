import 'package:flutter/material.dart';
import 'package:pingo_learn_news_app/models/news_channel_headline_model.dart';

class NewsDetailsPage extends StatelessWidget {
  final Articles article;
  const NewsDetailsPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image.network(article.urlToImage ?? ''),
              SizedBox(
                height: 200,
                child: article.urlToImage != null
                    ? Image.network(article.urlToImage ?? '')
                    : Center(child: Text('No Image Preview')),
              ),

              const SizedBox(height: 16.0),
              Text(
                article.title ?? '',
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                article.author ?? '',
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                article.description ?? '',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              Text(
                article.publishedAt ?? '',
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Handle opening the news article in a web view
                },
                child: const Text('Read Full Article'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
