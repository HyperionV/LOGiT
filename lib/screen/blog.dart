// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:logit/model/article.dart';
import 'package:logit/widget/bookmark.dart';
import 'package:logit/widget/discovery.dart';
import 'package:logit/screen/notification.dart';
import 'package:logit/screen/health_diary.dart';
import 'package:logit/screen/reminder.dart';

class HealthBlog extends StatefulWidget {
  const HealthBlog({Key? key});

  @override
  _HealthBlogState createState() => _HealthBlogState();
}

class _HealthBlogState extends State<HealthBlog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
            ),
            child: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.search),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for articles, titles, etc.',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Text(
              'Bookmarked',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 210,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: bookmarkedArticles.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: BookmarkCard(bookmarkedArticles[index]),
                  );
                },
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Text(
              'Discovery',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: bookmarkedArticles.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  child: DiscoveryCard(bookmarkedArticles[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
