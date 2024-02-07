import 'package:flutter/material.dart';
import 'package:logit/model/article.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BookmarkCard extends StatelessWidget {
  const BookmarkCard(this.article, {super.key});

  final Article article;

  Future<void> _launchURL(context) async {
    final String url = article.url;
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.inAppWebView);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch ${article.title}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _launchURL(context);
      },
      child: SizedBox(
        width: 175,
        height: 200,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(
              color: Color.fromARGB(255, 211, 211, 211),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                    child: Image.network(
                      article.imageUrl,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    article.title,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: Row(
                    children: [
                      const SizedBox(width: 4),
                      Text(
                        article.publishedAt,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 179, 236, 188),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          article.tag,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 72, 156, 66),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
