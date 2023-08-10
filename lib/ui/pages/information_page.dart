import 'package:flutter/material.dart';
import 'package:jti_warehouse_driver/ui/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({super.key});

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
    Navigator.pushNamedAndRemoveUntil(
        context, '/sign-in', ModalRoute.withName('/sign-in'));
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Informasi'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.orangeAccent,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              _logout();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Log Out Berhasil"),
                backgroundColor: Colors.greenAccent,
                duration: Duration(seconds: 2),
              ));
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
      ),
    );
  }
}
