
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jti_warehouse_driver/ui/pages/bottom_bar/bottombar_model/bottom_navy_bar_item.dart';


class AppData{
  const AppData._();

  static List<BottomNavyBarItem> bottomNavyBarItems = [
    BottomNavyBarItem(
      "Home",
      const Icon(Icons.home),
      // Colors.blue,
      // const Color(0xFFE0A56B),
      const Color(0xFFCE822B),
      Colors.grey,

    ),
    BottomNavyBarItem(
      "History",
      const Icon(Icons.history),
      const Color(0xFFCE822B),
      Colors.grey,

    ),
    BottomNavyBarItem(
      "Information",
      const Icon(Icons.info_rounded),
      const Color(0xFFCE822B),
      Colors.grey,

    ),
    // BottomNavyBarItem(
    //   "Profile",
    //   const Icon(Icons.person),
    //   const Color(0xFF6F9C95),
    //   Colors.grey,
    // ),
  ];
}