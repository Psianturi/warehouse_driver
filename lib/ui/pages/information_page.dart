import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jti_warehouse_driver/api/constant.dart';
import 'package:jti_warehouse_driver/api/key.dart';
import 'package:jti_warehouse_driver/ui/pages/home_page.dart';
import 'package:jti_warehouse_driver/ui/pages/models/scan_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class InformationPage extends StatefulWidget {
  const InformationPage({super.key});

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  Map<String, dynamic> userData = {};
  Map<String, dynamic> userData2 = {};

  // User? userData;

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
    Navigator.pushNamedAndRemoveUntil(
        context, '/sign-in', ModalRoute.withName('/sign-in'));
  }

  Future<void> fetchDataUser(int id) async {
    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.getLocation + id.toString() );
    final response = await http.get(url,
        headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final userDataMap = data["data"][0]["id_track_driver"]["user"];
      final userDataTransport = data["data"][0]["id_track_driver"]["transport"];
      print("Data berhasil ditampilkan $userDataMap" );

      setState(() {
        userData = userDataMap;
        userData2 = userDataTransport ;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDataUser( 1);
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

      body: Center(
        child: userData.isEmpty && userData2.isEmpty
            ? const CircularProgressIndicator() // Loading indicator
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Container(
          width: 140,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: userData["photo"] == null
                  ? NetworkImage(userData["photo"])
                  : const NetworkImage(
                  "https://ouch-cdn2.icons8.com/84zU-uvFboh65geJMR5XIHCaNkx-BZ2TahEpE9TpVJM/rs:fit:784:784/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9wbmcvODU5/L2E1MDk1MmUyLTg1/ZTMtNGU3OC1hYzlh/LWU2NDVmMWRiMjY0/OS5wbmc.png")
              as ImageProvider,
            ),
          ),

        ),
            const SizedBox( height: 30,),

            Text('Name: ${userData["name"]}'),
            SizedBox( height: 10),
            Text('Email: ${userData["email"]}'),
            SizedBox( height: 10),
            Text('Phone: ${userData["phone"]}'),
            SizedBox( height: 10),
            Text('Role Id: ${userData["role_id"]}'),
            SizedBox( height: 10),

            Text('Kendaraan: ${userData2["type"]}'),
            SizedBox( height: 10),
            Text('Posisi: ${userData2["driver"]}'),

          ],
        ),
      ),
    );

  }
}
