// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:logit/screen/blog.dart';
import 'package:logit/screen/notification.dart';
import 'package:logit/screen/health_diary.dart';
import 'package:logit/screen/reminder.dart';
import 'package:logit/widget/header.dart';

const List<String> titles = [
  'Health Blog',
  'Health Diary',
  'Notifications',
  'Reminders',
];

const List<Widget> screens = [
  HealthBlog(),
  HealthDiary(),
  NotificationScreen(),
  ReminderScreen(),
];

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() {
    return _MainScreenState();
  }
}

int _currentIndex = 0;

class _MainScreenState extends State<MainScreen> {
  PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            ScreenHeader(titles[_currentIndex]),
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: List.generate(4, (index) => screens[index]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GNav(
        gap: 4,
        color: const Color.fromARGB(255, 75, 153, 78),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        activeColor: const Color.fromARGB(255, 203, 26, 13),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        onTabChange: (value) {
          navigationTapped(value);
          setState(() {
            _currentIndex = value;
          });
        },
        selectedIndex: _currentIndex,
        tabs: const [
          GButton(icon: Icons.home, text: 'Home'),
          GButton(icon: Icons.health_and_safety, text: 'Health Diary'),
          GButton(icon: Icons.notifications_on, text: 'Notifications'),
          GButton(icon: Icons.event_note_rounded, text: 'Reminders')
        ],
      ),
    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
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
