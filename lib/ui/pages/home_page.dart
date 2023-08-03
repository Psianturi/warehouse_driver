import 'package:background_fetch/background_fetch.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jti_warehouse_driver/main.dart';
import 'package:latlong2/latlong.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LatLng _driverLocation = LatLng(-6.1754, 106.8272); // Default location (example for Jakarta)
  final Faker _faker = Faker();
  FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

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
        minimumFetchInterval: 3, // interval dalam menit untuk pembaruan lokasi (atur sesuai kebutuhan Anda)
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
  Future<void> onFetch(String taskId) async {
    print("[BackgroundFetch] Event received: $taskId");
    if (await Geolocator.isLocationServiceEnabled()) {
      // Memperbarui lokasi driver saat di dalam aplikasi
      _updateDriverLocation();
      _showSnackbar(); // Menampilkan snackbar saat di dalam aplikasi
    } else {
      _showPopup(); // Menampilkan popup saat di luar aplikasi
      _updateDriverLocation();
      print("PopUp berhasil ditampilkan $_showPopup()");
    }
    //kondisi jika aplikasi berjalan di latar belakang(onStop)
    if(BackgroundFetch.status == BackgroundFetch.stop()){
      _showPopup();
      print("Pop up berhasil ditampilkan $_showPopup()");
    }
    // _showPopup();
    // print("Pop up berhasil ditampilkan $_showPopup()");

    BackgroundFetch.finish(taskId); // Memberitahu sistem bahwa tugas telah selesai
  }

  void _updateDriverLocation() async {
    // Untuk menghasilkan lokasi driver yang acak
    double latitude = double.parse(_faker.geo.latitude().toString());
    double longitude = double.parse(_faker.geo.longitude().toString());

    setState(() {
      _driverLocation = LatLng(latitude, longitude);
    });
  }

  Future<void> _showPopup() async {

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'channel_id', // ID unik untuk channel notifikasi
      'jti_01', // Nama channel notifikasi
      // 'channel_description', // Deskripsi channel notifikasi
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    // const IOSNotificationDetails iOSPlatformChannelSpecifics =
    // IOSNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      // iOS: iOSPlatformChannelSpecifics,
    );

    // Menampilkan notifikasi dengan ID unik 0
    await flutterLocalNotificationsPlugin.show(
      0,
      'Water Bill Due',
      'Monthly Water Bill Due',
      platformChannelSpecifics,
    );

    // var androidDetails = const AndroidNotificationDetails(
    //   'channel_id',
    //   'Channel Name',
    //   // 'Channel Description',
    //   importance: Importance.max,
    //   priority: Priority.high,
    // );
    // // var iosDetails = IOSNotificationDetails();
    //
    // var notificationDetails = NotificationDetails(android: androidDetails,
    //     // iOS: iosDetails
    // );
    //
    // await _localNotifications.show(
    //   0, // id notifikasi, harus unik untuk setiap notifikasi
    //   'Driver Location Update',
    //   'Driver location has been updated outside the app.',
    //   notificationDetails,
    // );
  }

  void _showSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Lokasi Driver diperbarui'),
        duration: Duration(seconds: 6),
      ),
    );
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
