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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final _formKey = GlobalKey<FormBuilderState>();

  LocationData _driverLocation = LocationData(
    latitude: -6.1754,
    longitude: 106.8272,
    elevation: 0.0,
    speed: 0.0,
  );
  final Faker _faker = Faker();
  FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    // Inisialisasi background_fetch
    initBackgroundFetch();

    // Memperbarui lokasi sekali saat aplikasi dijalankan
    _updateDriverLocation();

  }

  // @override
  // void dispose() {
  //   // Hentikan background service saat widget dihapus
  //   if (FlutterBackgroundService().isServiceRunning) {
  //     FlutterBackgroundService().stop();
  //   }
  //   super.dispose();
  // }

  // Inisialisasi background_fetch dengan mengatur fungsi yang akan dipanggil di latar belakang
  void initBackgroundFetch() {
    BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 12,
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

  void _updateDriverLocation() async {
    // Untuk menghasilkan lokasi driver yang acak
    double latitude = double.parse(_faker.geo.latitude().toString());
    double longitude = double.parse(_faker.geo.longitude().toString());
    double elevasi = double.parse(_faker.randomGenerator.decimal().toStringAsFixed(2));
    double kecepatan = double.parse(_faker.randomGenerator.decimal(min: 0, scale: 100).toStringAsFixed(2));


    setState(() {
      _driverLocation = LocationData(
        latitude: latitude,
        longitude: longitude,
        elevation: elevasi,
        speed: kecepatan,
      );
    });
    // Panggil fungsi untuk mengirim pembaruan lokasi ke endpoint API
    await _sendLocationUpdateToAPI(latitude, longitude, elevasi, kecepatan);

  }
  Future<void> _sendLocationUpdateToAPI(
      double latitude,
      double longitude,
      double elevasi,
      double kecepatan,
      ) async {
    // String apiUrl = '{{url}}/driver/update_location_driver/1';
    final requestBody =
        '{"latitude": "$latitude", "longitude": "$longitude", "elevasi": "$elevasi", "kecepatan": "$kecepatan"}';

    try {
      final response = await put(Uri.parse(ApiConstants.baseUrl + ApiConstants.updateLocation ),
          body: requestBody);
      if (response.statusCode == 200) {
        print('Location updated successfully');
      } else {
        print('Failed to update location');
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

    // const IOSNotificationDetails iOSPlatformChannelSpecifics =
    // IOSNotificationDetails();

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
      appBar: AppBar(title: Text('Transaction'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.orangeAccent,
        automaticallyImplyLeading: false,
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
                const SizedBox(height: 7),
                FormBuilderTextField(
                  name: 'from',
                  textInputAction: TextInputAction.next,
                  //when enter is pressed, it will go to the next field
                  decoration:
                      const InputDecoration(labelText: 'Pengiriman Dari'),
                  initialValue: 'Quary JTI',
                  readOnly: true,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                const SizedBox(height: 7),
                FormBuilderTextField(
                  name: 'to',
                  textInputAction: TextInputAction.next,
                  //when enter is pressed, it will go to the next field
                  decoration:
                      const InputDecoration(labelText: 'Tujuan Pengiriman'),
                  initialValue: 'Warehouse Bojonegara',
                  readOnly: true,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                const SizedBox(height: 7),
                FormBuilderDateTimePicker(
                  name: 'date',
                  initialEntryMode: DatePickerEntryMode.calendar,
                  // initialValue: DateTime.now(),
                  initialValue: DateTime(2023, 8, 4),
                  enabled: false,
                  inputType: InputType.both,
                  decoration: const InputDecoration(
                    labelText: 'Waktu Transaksi',
                    // suffixIcon: IconButton(
                    //   icon: const Icon(Icons.close),
                    //   onPressed: () {
                    //     _formKey.currentState!.fields['date']?.didChange(null);
                    //   },
                    // ),
                  ),
                  initialTime: const TimeOfDay(hour: 8, minute: 0),
                  // locale: const Locale.fromSubtags(languageCode: 'fr'),
                ),
                const SizedBox(height: 7),
                FormBuilderTextField(
                  name: 'produk',
                  textInputAction: TextInputAction.next,
                  //when enter is pressed, it will go to the next field
                  decoration:
                  const InputDecoration(labelText: 'Nama Produk'),
                  initialValue: 'Batu split 1/2',
                  readOnly: true,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),

                const SizedBox(height: 75),

            Center(
                child: AlertDialog(
                  insetPadding:  EdgeInsets.zero,
                  shadowColor: Colors.greenAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  title: const Text('Lokasi Driver',
                    style: TextStyle(fontSize: 16), textAlign: TextAlign.center,
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Latitude: ${_driverLocation.latitude}',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Longitude: ${_driverLocation.longitude}',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Elevasi: ${_driverLocation.elevation}',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Kecepatan: ${_driverLocation.speed}',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Last Updated: ${DateTime.now().toString()}',
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _updateDriverLocation();
                        },
                        child: const Text('UpdateLocation API'),
                      ),
                    ],
                  ),

                  // child:
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   mainAxisSize: MainAxisSize.max,
                  //   children: [
                  //     const SizedBox(height: 12),
                  //     Text(
                  //       'Lokasi Driver',
                  //       style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  //     ),
                  //     SizedBox(height: 10),
                  //     Text(
                  //       'Latitude: ${_driverLocation.latitude}',
                  //       style: TextStyle(fontSize: 16),
                  //     ),
                  //     SizedBox(height: 5),
                  //     Text(
                  //       'Longitude: ${_driverLocation.longitude}',
                  //       style: TextStyle(fontSize: 16),
                  //     ),
                  //     SizedBox(height: 18),
                  //     Text(
                  //       'Last Updated: ${DateTime.now().toString()}',
                  //       textAlign: TextAlign.left,
                  //       textDirection: TextDirection.ltr,
                  //       style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                  //     ),
                  //     const SizedBox(height: 12),
                  //   ],
                  // ),

                ),
              ),


              ],
            ),
          )),


      // child:
      // Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     children: [
      //       Text(
      //         'Lokasi Driver',
      //         style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      //       ),
      //       SizedBox(height: 10),
      //       Text(
      //         'Latitude: ${_driverLocation.latitude}',
      //         style: TextStyle(fontSize: 16),
      //       ),
      //       SizedBox(height: 5),
      //       Text(
      //         'Longitude: ${_driverLocation.longitude}',
      //         style: TextStyle(fontSize: 16),
      //       ),
      //       SizedBox(height: 18),
      //       Text(
      //         'Last Updated: ${DateTime.now().toString()}',
      //         style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
      //       ),
      //       SizedBox(height: 15),
      //     ],
      //   ),
      // ),
    );
  }
}
