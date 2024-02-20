// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:logit/model/user.dart';
import 'package:logit/screen/notification.dart';
import 'package:logit/doctor/screen/health_diary.dart';
import 'package:logit/screen/profile.dart';
import 'package:logit/screen/reminder.dart';
import 'package:firebase_auth/firebase_auth.dart';

const List<String> titles = [
  'Profile',
  'Health Diary',
  'Notifications',
  'Reminders',
];

class MainScreenDoctor extends StatefulWidget {
  MainScreenDoctor({super.key})
      : initialPage = 1,
        selectedDate = null;

  int initialPage;
  final DateTime? selectedDate;

  MainScreenDoctor.openAt(this.initialPage, {super.key})
      : selectedDate = DateTime.now();

  MainScreenDoctor.openReminderAt({
    super.key,
    this.initialPage = 1,
    this.selectedDate,
  });

  @override
  State<MainScreenDoctor> createState() {
    return _MainScreenDoctorState();
  }
}

class _MainScreenDoctorState extends State<MainScreenDoctor> {
  PageController _pageController = PageController(initialPage: 1);

  late UserData user;

  @override
  void initState() {
    // initUser();
    _pageController = PageController(initialPage: widget.initialPage);
    super.initState();
  }

  Future<void> initUser() async {
    user = await fetchWithUID(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: initUser(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    children: [
                      ProfileScreen(user),
                      HealthDiary(),
                      NotificationScreen(),
                      if (widget.selectedDate != null)
                        ReminderScreen.openAt(
                            Timestamp.fromDate(widget.selectedDate!))
                      else
                        ReminderScreen(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: GNav(
        gap: 4,
        color: const Color.fromARGB(255, 75, 153, 78),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        activeColor: const Color.fromARGB(255, 203, 26, 13),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        onTabChange: (value) {
          navigationTapped(value);
        },
        selectedIndex: widget.initialPage,
        tabs: const [
          GButton(icon: Icons.person, text: 'Profile'),
          GButton(icon: Icons.health_and_safety, text: 'Health Diary'),
          GButton(icon: Icons.notifications_on, text: 'Notifications'),
          GButton(icon: Icons.event_note_rounded, text: 'Reminders')
        ],
      ),
    );
  }

  void navigationTapped(int page) {
    widget.initialPage = page;
    _pageController.jumpToPage(page);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// // class _HomeScreenState extends State<HomeScreen> {
//   PageController _pageController = PageController(initialPage: 0);
//   int _currentIndex = 0;

//   void _onTabChange(int value) {
//     setState(() {
//       _currentIndex = value;
//     });
//     _pageController.animateToPage(
//       value,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ScreenHeader(titles[_currentIndex]),
//             Expanded(
//               child: PageView(
//                 controller: _pageController,
//                 onPageChanged: (index) {
//                   setState(
//                     () {
//                       _currentIndex = index;
//                     },
//                   );
//                 },
//                 children: const [
//                   HealthBlog(),
//                   HealthDiary(),
//                   NotificationScreen(),
//                   ReminderScreen(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
      // bottomNavigationBar: GNav(
      //   gap: 4,
      //   color: const Color.fromARGB(255, 75, 153, 78),
      //   backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      //   activeColor: const Color.fromARGB(255, 203, 26, 13),
      //   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      //   onTabChange: (value) {
      //     _onTabChange(value);
      //   },
      //   selectedIndex: _currentIndex,
      //   tabs: const [
      //     GButton(icon: Icons.health_and_safety, text: 'Health Diary'),
      //     GButton(icon: Icons.notifications_on, text: 'Notifications'),
      //     GButton(icon: Icons.event_note_rounded, text: 'Reminders')
      //   ],
      // ),
//     );
//   }
// }
