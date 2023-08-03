import 'package:background_fetch/background_fetch.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   static List<Widget> screens = [
//
//   ];
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//
//       return const SafeArea(
//           child: Text('Halaman Beranda'
//           ),
//       );
//   }
//
// }


class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LatLng _driverLocation = LatLng(-6.1754, 106.8272); // Default location (example for Jakarta)
  final Faker _faker = Faker();

  @override
  void initState() {
    super.initState();

    // Inisialisasi background_fetch
    initBackgroundFetch();

    // Memperbarui lokasi sekali saat aplikasi dijalankan
    _updateDriverLocation();
  }

  // Inisialisasi background_fetch dengan mengatur fungsi yang akan dipanggil di latar belakang
  void initBackgroundFetch() {
    BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 5, // interval dalam menit untuk pembaruan lokasi (atur sesuai kebutuhan Anda)
        stopOnTerminate: false,
        enableHeadless: true,
        forceAlarmManager: false,
        startOnBoot: true,
      ),
      onFetch,
          (String taskId) async {
        print("[BackgroundFetch] Event received: $taskId");
        BackgroundFetch.finish(taskId);
      },
    );
  }

  // Fungsi yang akan dijalankan oleh background_fetch
  void onFetch(String taskId) async {
    print("[BackgroundFetch] Event received: $taskId");
     _updateDriverLocation(); // Memperbarui lokasi driver

    BackgroundFetch.finish(taskId); // Memberitahu sistem bahwa tugas telah selesai
  }

  void _updateDriverLocation() async {
    // Contoh untuk menghasilkan lokasi driver yang acak
    double latitude = double.parse(_faker.geo.latitude().toString());
    double longitude = double.parse(_faker.geo.longitude().toString());

    setState(() {
      _driverLocation = LatLng(latitude, longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Driver Location')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Lokasi Driver',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Latitude: ${_driverLocation.latitude}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              'Longitude: ${_driverLocation.longitude}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 18),
            Text(
              'Last Updated: ${DateTime.now().toString()}',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
