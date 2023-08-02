import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:jti_warehouse_driver/ui/pages/bottom_bar/bottom_bar_menu.dart';
import 'dart:ui' show PointerDeviceKind;
import 'package:jti_warehouse_driver/ui/pages/home_page.dart';
import 'package:jti_warehouse_driver/ui/pages/login_page.dart';
import 'package:jti_warehouse_driver/ui/pages/scan_page/barcode_scanner.dart';
import 'package:jti_warehouse_driver/ui/pages/signup_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
          },
        ),
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(
              color: Colors.black54,
            ),
            titleTextStyle: TextStyle(
              color: Colors.black54,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),

        ),
        routes: {
          '/': (context) => const LoginPage(),
          '/sign-in': (context) => const LoginPage(),
          '/sign-up': (context) => const SignUpPage(),
          '/home': (context) => const HomePage(),
          '/bottom-menu': (context) => const BottomBarMenu(),
          '/barcode-scan': (context) => const ScanPage(),
        }

    );
  }
}



