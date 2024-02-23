// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logit/screen/auth.dart';
import 'package:logit/patient/home.dart';
import 'package:logit/doctor/screen/home.dart';
import 'miscellaneous/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logit/model/event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

var colorScheme =
    ColorScheme.fromSeed(seedColor: Color.fromARGB(1, 87, 191, 156));

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(context) {
    return MaterialApp(
      theme: ThemeData().copyWith(
          colorScheme: colorScheme,
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Color.fromARGB(255, 255, 255, 255),
              surfaceTintColor: Colors.white),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primaryContainer,
              shadowColor: colorScheme.primaryContainer,
              elevation: 0,
            ),
          ),
          textTheme: ThemeData().textTheme.copyWith(
                titleLarge: TextStyle(
                  color: colorScheme.onPrimaryContainer,
                ),
              )),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(snapshot.data!.uid)
                    .get(),
                builder:
                    (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.done) {
                    if (userSnapshot.hasData && userSnapshot.data!.exists) {
                      Map<String, dynamic> userData =
                          userSnapshot.data!.data() as Map<String, dynamic>;
                      fetchEvents();
                      if (userData['isDoctor'] as bool == true) {
                        return MainScreenDoctor();
                      } else {
                        return MainScreen();
                      }
                    } else {
                      return AuthScreen();
                    }
                  }
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              );
            } else {
              return AuthScreen();
            }
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
