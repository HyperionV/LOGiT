import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Article {
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final String tag;
  final String publishedAt;

  Article(
    this.title,
    this.description,
    this.url,
    this.imageUrl,
    this.tag,
    this.publishedAt,
  );
}

Future<List<Article>> fetchArticlesData() async {
  final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();

  if (userSnapshot.exists) {
    final QuerySnapshot<Map<String, dynamic>> articlesSnapshot =
        await userSnapshot.reference.collection('articles').get();

    final List<Article> articles = [];

    for (final articleDoc in articlesSnapshot.docs) {
      final data = articleDoc.data();
      final article = Article(
        data['title'],
        data['description'],
        data['url'],
        data['imageUrl'],
        data['tag'],
        data['publishedAt'],
      );
      articles.add(article);
    }

    return articles;
  } else {
    throw Exception('User data not found');
  }
}

List<Article> discovery = [
  Article(
    'Rồng Bình Dương đón tết siêu đẹp trai',
    'Drinking water is essential for your health. It helps you stay hydrated, which is important for your body to function properly.',
    'http://google.com',
    'https://img-s-msn-com.akamaized.net/tenant/amp/entityid/BB1hNtls.img?w=768&h=432&m=6&x=144&y=936&s=60&d=60',
    'Health',
    '2021-10-01',
  ),
  Article(
    'Gojo tuyên bố anh ấy sẽ thắng',
    'Drinking water is essential for your health. It helps you stay hydrated, which is important for your body to function properly.',
    'https://www.healthline.com/hlcmsresource/images/topic_centers/2019-1/Drinking_Water-732x549-thumbnail.jpg',
    'https://i.kym-cdn.com/entries/icons/original/000/047/210/nah_id_win.jpg',
    'Anime',
    '2021-10-01',
  ),
  Article(
    'Rồng Bình Dương đón tết siêu đẹp trai',
    'Drinking water is essential for your health. It helps you stay hydrated, which is important for your body to function properly.',
    'https://www.healthline.com/hlcmsresource/images/topic_centers/2019-1/Drinking_Water-732x549-thumbnail.jpg',
    'https://img-s-msn-com.akamaized.net/tenant/amp/entityid/BB1hNtls.img?w=768&h=432&m=6&x=144&y=936&s=60&d=60',
    'Health',
    '2021-10-01',
  ),
  Article(
    'Rồng Bình Dương đón tết siêu đẹp trai',
    'Drinking water is essential for your health. It helps you stay hydrated, which is important for your body to function properly.',
    'https://www.healthline.com/hlcmsresource/images/topic_centers/2019-1/Drinking_Water-732x549-thumbnail.jpg',
    'https://img-s-msn-com.akamaized.net/tenant/amp/entityid/BB1hNtls.img?w=768&h=432&m=6&x=144&y=936&s=60&d=60',
    'Health',
    '2021-10-01',
  ),
];
