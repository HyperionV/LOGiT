import 'package:flutter/material.dart';
import 'package:logit/screen/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logit/screen/home.dart';
import 'miscellaneous/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
    );
  }
}
