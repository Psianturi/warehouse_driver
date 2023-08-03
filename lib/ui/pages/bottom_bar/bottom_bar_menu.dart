
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:jti_warehouse_driver/ui/pages/bottom_bar/app_data.dart';
import 'package:jti_warehouse_driver/ui/pages/history_page.dart';
import 'package:jti_warehouse_driver/ui/pages/home_page.dart';
import 'package:jti_warehouse_driver/ui/pages/information_page.dart';

class BottomBarMenu extends StatefulWidget {
  const BottomBarMenu({Key? key}) : super(key: key);

  static List<Widget> screens = [
    HomePage(),
    const HistoryPage(),
    const InformationPage(),
  ];

  @override
  State<BottomBarMenu> createState() => _BottomBarMenuState();
}

class _BottomBarMenuState extends State<BottomBarMenu> {
  int newIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavyBar(
          iconSize: 30,
          containerHeight: 60,
          itemCornerRadius: 30,
          selectedIndex: newIndex,
          items: AppData.bottomNavyBarItems
              .map(
                (item) => BottomNavyBarItem(
              icon: item.icon,
              title: Text(item.title),
              activeColor: item.activeColor,
              inactiveColor: item.inActiveColor,
            ),
          ) .toList(),
          onItemSelected: (currentIndex) {
            newIndex = currentIndex;
            setState(() {});
          },
        ),
        body: PageTransitionSwitcher(
          duration: const Duration(seconds: 1),
          transitionBuilder: (
              Widget child,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              ) {
            return FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
          child: BottomBarMenu.screens[newIndex],
        ),
      ),
    );
  }

}