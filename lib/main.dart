
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jti_warehouse_driver/ui/pages/bottom_bar/bottom_bar_menu.dart';
import 'dart:ui' show PointerDeviceKind;
import 'package:jti_warehouse_driver/ui/pages/home_page.dart';
import 'package:jti_warehouse_driver/ui/pages/login_page.dart';
import 'package:jti_warehouse_driver/ui/pages/scan_page/barcode_scanner.dart';
import 'package:jti_warehouse_driver/ui/pages/signup_page.dart';
import 'package:jti_warehouse_driver/ui/pages/transaction/transaction_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   runApp(const MyApp());
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString("");
  print(email);

  // Inisialisasi plugin notifikasi lokal
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const MyApp());
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
          },
        ),
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Poppins-Regular',
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
          '/barcode-scan': (context) =>  const ScanPage(),
          '/transaction': (context) => const TransactionPage(),
        });
  }
}
