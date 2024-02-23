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
    'Kidney Failure: Causes, Symptoms & Treatment',
    'Drinking water is essential for your health. It helps you stay hydrated, which is important for your body to function properly.',
    'https://my.clevelandclinic.org/health/diseases/17689-kidney-failure',
    'https://my.clevelandclinic.org/-/scassets/images/org/health/articles/17689-kidney-failure',
    'Health',
    '2022-10-01',
  ),
  Article(
    'Acute kidney failure - Symptoms and causes',
    'Stress is a normal part of life. In small quantities, stress is good — it can motivate you and help you be more productive. However, too much stress, or a strong response to stress, is harmful.',
    'https://www.mayoclinic.org/diseases-conditions/kidney-failure/symptoms-causes/syc-20369048',
    'https://www.mayoclinic.org/-/media/kcms/gbs/patient-consumer/images/2013/11/15/17/35/ds00280_-ds00360_-ds00503_-ds00682_-ds00856_-ds01047_im00767_r7_kidneysectionthu_2_jpg.jpg',
    'Health',
    '2021-10-01',
  ),
  Article(
    'Kidney-friendly eating plan',
    'Stress is a normal part of life. In small quantities, stress is good — it can motivate you and help you be more productive. However, too much stress, or a strong response to stress, is harmful.',
    'https://www.kidneyfund.org/living-kidney-disease/healthy-eating-activity/kidney-friendly-eating-plan',
    'https://www.kidneyfund.org/sites/default/files/styles/hero_bg/public/media/images/Food%20and%20people%20eating%20or%20cooking/People%20eating%20_%20with%20food/black-pair-at-cooking-class-blue-aprons.jpg?itok=Rx2BEs8j',
    'Diet Plan',
    '2023-10-02',
  ),
];
