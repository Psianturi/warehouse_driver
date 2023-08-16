import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jti_warehouse_driver/api/constant.dart';
import 'package:jti_warehouse_driver/api/key.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'models/user_model.dart';


class InformationPage extends StatefulWidget {
  const InformationPage({super.key});

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  // Map<String, dynamic> userData = {};
  User? userData;
  int? idNya;


  void loadId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
     idNya = prefs.getInt('id') ?? 0; // Gunakan default value jika tidak ditemukan
      print("idNya $idNya");
    });
    fetchDataUser(idNya!);
  }

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
    Navigator.pushNamedAndRemoveUntil(
        context, '/sign-in', ModalRoute.withName('/sign-in'));
  }

  Future<UserModel> fetchDataUser(int id) async {
    var url = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.getLocation + id.toString());
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    });

    if (response.statusCode == 200) {

      print("Data berhasil ditampilkan ${response.body}");
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    // fetchDataUser(1);
    loadId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body:
      FutureBuilder<UserModel>(
        future: fetchDataUser(1), // Call the function to fetch user data
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            final userData = snapshot.data!.data?.first;
            final transport = userData?.idTrackDriver?.numberVehicle;
            final user = userData?.idTrackDriver?.user;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                   Center(
                child:
                  CircleAvatar(
                    radius: 50, // Adjust the radius as needed
                    // kondisi jika user database tidak mempunyai foto, maka gunakan network image
                    backgroundImage: NetworkImage(
                        user?.photo ??
                            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),

                  ),),
                  const SizedBox(height: 22),
                  Text('Nama Pengemudi: ${user?.name ?? ''}'),
                  SizedBox(height: 14),
                  Text('Nomor Kendaraan: ${transport ?? ''}'),
                  SizedBox(height: 14),
                  Text('Email Pengemudi: ${user?.email ?? ''}'),
                  SizedBox(height: 14),
                  Text('Nomor Telepon: ${user?.phone ?? ''}'),
                  // Text('Status Kendaraan: ${transport?.status ?? ''}'),
                ],
              ),
            );
          } else {
            return Text('No data available');
          }
        },
      ),

      // body: Center(
      //   child: userData==null && userData2.isEmpty
      //       ? const CircularProgressIndicator() // Loading indicator
      //       : Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //     Container(
      //     width: 140,
      //     height: 150,
      //     decoration: const BoxDecoration(
      //       shape: BoxShape.circle,
      //       image: DecorationImage(
      //         image: NetworkImage(
      //             'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
      //         fit: BoxFit.fill,
      //       ),
      //     ),
      //
      //   ),
      //       const SizedBox( height: 30,),
      //
      //       Text('Nama: ${user?.name ?? ''}'),
      //       Text('Email: ${user?.email ?? ''}'),
      //
      //
      //
      //       Text('Kendaraan: ${userData2["type"]}'),
      //       const SizedBox( height: 10),
      //       Text('Posisi: ${userData2["driver"]}'),
      //
      //     ],
      //   ),
      // ),
    );
  }
}
