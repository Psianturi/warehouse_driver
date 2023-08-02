import 'package:flutter/material.dart';
import 'package:jti_warehouse_driver/widgets/page_wrapper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static List<Widget> screens = [

  ];

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

      return const SafeArea(
          child: Text('Halaman Beranda'
          ),
      );
  }
 
}

