import 'dart:convert';
import 'dart:io';

import 'package:background_fetch/background_fetch.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:jti_warehouse_driver/api/constant.dart';
import 'package:jti_warehouse_driver/main.dart';
import 'package:jti_warehouse_driver/ui/pages/models/LocationData.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:battery_plus/battery_plus.dart';
import '../../api/key.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _formKey = GlobalKey<FormBuilderState>();

   LocationData _driverLocation = LocationData(
    lat: -6.1754,
    long: 106.8272,
    elevasi: 0.0,
    kecepatan: 1.0,
    battery: 50,
  );
  // Instantiate it
  var battery = Battery();
  final Faker _faker = Faker();
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

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
        minimumFetchInterval: 15,
        // interval dalam menit untuk pembaruan lokasi (atur sesuai kebutuhan Anda)
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

  Future <void> _updateDriverLocation() async {
    // Untuk menghasilkan lokasi driver yang acak
    double lat = double.parse(_faker.geo.latitude().toString());
    double long = double.parse(_faker.geo.longitude().toString());
    double elevasi = double.parse(_faker.randomGenerator.decimal().toStringAsFixed(2));
    double kecepatan = double.parse(_faker.randomGenerator.decimal(min: 0, scale: 100).toStringAsFixed(2));
    int batteryLevel = int.parse(( battery.batteryLevel).toString());

    // double lat = _driverLocation.lat;
    // double long = _driverLocation.long;
    // double elevasi = _driverLocation.elevasi;
    // double kecepatan = _driverLocation.kecepatan;

    // Untuk menghasilkan lokasi driver yang sebenarnya
    // Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // double lat;
    // double long;
    // double elevasi;
    // double kecepatan;
    //
    // lat = position.latitude;
    // long = position.longitude;
    // elevasi = position.altitude;
    // kecepatan = position.speed;



    setState(() {
      // Memperbarui lokasi driver
      _driverLocation = LocationData(
        lat: lat,
        long: long,
        elevasi: elevasi,
        kecepatan: kecepatan,
        battery: batteryLevel,
      );
    });
    // Panggil fungsi untuk mengirim pembaruan lokasi ke endpoint API
    await _sendLocationUpdateToAPI(lat, long, elevasi, kecepatan, batteryLevel, 1);
  }

  // Fungsi yang akan dijalankan oleh background_fetch
  Future<void> onFetch(String taskId) async {
    print("[BackgroundFetch] Event received: $taskId");
    if (await Geolocator.isLocationServiceEnabled()) {
      // Memperbarui lokasi driver
      _updateDriverLocation();
      _showSnackbar();
      _showPopup();

      print(
          "PopUpnyaaaa berhasil ditampilkan $_showPopup()"); // Menampilkan snackbar saat di dalam aplikasi
    } else {
      print("Location service disabled");
    }
    //kondisi jika aplikasi berjalan di latar belakang(onStop)
    if (BackgroundFetch.status == BackgroundFetch.stop()) {
      _showPopup();
      print("Pop up berhasil ditampilkan $_showPopup()");
    }

    BackgroundFetch.finish(
        taskId); // Memberitahu sistem bahwa tugas telah selesai
  }


  Future<void> _sendLocationUpdateToAPI(double lat,
      double long,
      double elevasi,
      double kecepatan,
      int batteryLevel,
      int id,
      ) async {
    // String apiUrl = '{{url}}/driver/update_location_driver/1';
    final requestBody = json.encode(
        {
          "lat": "$lat",
          "long": "$long",
          "elevasi": "$elevasi",
          "kecepatan": "$kecepatan"
        });

    try {
      final response = await put(
          Uri.parse(ApiConstants.baseUrl + ApiConstants.updateLocation + id.toString()),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            'Authorization':
            'Bearer $bearerToken',
          },
          body: requestBody);
      if (response.statusCode == 200) {
        print('Location updated successfully');
        print('Response UpdateLokasi: ${response.statusCode}');
        print('Succsesssss to update location: ${response.body}');
      } else {
        print('Failed to update location: ${response.body}');
        print('Response UpdateLokasi: ${response.statusCode}');

      }
    } catch (e) {
      print('Error updating location: $e');
    }
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


    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      // iOS: iOSPlatformChannelSpecifics,
    );

    // Menampilkan notifikasi dengan ID unik 0
    await flutterLocalNotificationsPlugin.show(
      0,
      'JTI',
      'Update Lokasi Driver',
      platformChannelSpecifics,
    );


  }

  void _showSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Lokasi Driver diperbarui'),
        duration: Duration(seconds: 6),
      ),
    );
  }

  _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
    Navigator.pushNamedAndRemoveUntil(
        context, '/sign-in', ModalRoute.withName('/sign-in'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HOME'),
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
              _handleLogout();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Log Out Berhasil"),
                backgroundColor: Colors.greenAccent,
                duration: Duration(seconds: 2),
              ));
            },
            icon: const Icon(Icons.logout),
          ),],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
      ),
      body: FormBuilder(
        key: _formKey,
        onChanged: () {
          _formKey.currentState?.save();
          debugPrint(_formKey.currentState!.value.toString());
        },
        autovalidateMode: AutovalidateMode.disabled,
        skipDisabled: true,
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(14),
            child: Column(
                children: <Widget>[
            const SizedBox(height: 30),

                  const Text('Klik Untuk Scan Transaksi'),
            SizedBox(height: 12),
            FloatingActionButton(onPressed:
                () {
              Navigator.pushNamed(context, '/barcode-scan',
              );
            },

              backgroundColor: Colors.orangeAccent,
              child: const Icon(Icons.camera_alt_outlined,
                color: Colors.greenAccent,
                size: 35,),
            ),
            SizedBox(height: 10),

            const SizedBox(height: 40),


        Center(
          child: AlertDialog(
            insetPadding: EdgeInsets.zero,
            shadowColor: Colors.greenAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            title: const Text('GET INFO',
              style: TextStyle(fontSize: 16), textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Latitude: ${_driverLocation.lat}',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 5),
                Text(
                  'Longitude: ${_driverLocation.long}',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 5),
                Text(
                  'Elevasi: ${_driverLocation.elevasi}',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 5),
                Text(
                  'Kecepatan: ${_driverLocation.kecepatan}',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 5),
                Text(
                  'Baterry: ${_driverLocation.battery}',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 14),
                Text(
                  'Last Updated: ${DateTime.now().toString()}',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 14, fontStyle: FontStyle.italic),
                ),
                ElevatedButton(
                  onPressed: () {
                    _updateDriverLocation();
                    // _sendLocationUpdateToAPI( _driverLocation.lat, _driverLocation.long, _driverLocation.elevasi, _driverLocation.kecepatan);
                  },
                  child: const Text('UpdateLocation API'),
                ),
              ],
            ),



          ),
        ),


        ],
      ),
    )),

    );
  }
}
