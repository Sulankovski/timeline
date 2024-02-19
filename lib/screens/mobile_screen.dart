import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timeline/global_variables.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({super.key});

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  late PageController pageController;

  void navigationBarTapped(int page) {
    setState(() {
      pageController.jumpToPage(page);
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: homeScreenItems,
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: 1,
        backgroundColor: Colors.lightBlueAccent,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.map,
              color: Colors.white,
            ),
            backgroundColor: Colors.transparent,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            backgroundColor: Colors.transparent,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.event,
              color: Colors.white,
            ),
            backgroundColor: Colors.transparent,
          ),
        ],
        onTap: navigationBarTapped,
      ),
    );
  }
}
