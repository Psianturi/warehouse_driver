import 'dart:io';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jti_warehouse_driver/api/constant.dart';
import 'package:jti_warehouse_driver/ui/pages/models/scan_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  ScanModel? scanModel;
  String scannedBarcode = '';
  TextEditingController manualBarcodeController =
      TextEditingController(text: '');

  Future<void> _scanBarcode(BuildContext context) async {
    try {
      // Membaca kode barcode menggunakan plugin barcode_scan2
      // ScanResult result = await BarcodeScanner.scan();
      if (manualBarcodeController.text.isNotEmpty) {
        String barcode = manualBarcodeController.text;
        setState(() {
          scannedBarcode = barcode;
        });
        print("BarcodeNYA: $scannedBarcode");
        // Setelah scan selesai, pindah ke halaman transaksi
        Navigator.pushReplacementNamed(context, '/transaction');
      } else {
        // Jika pengguna membatalkan scan, tampilkan dialog
        _showScanFailedDialog(context);
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        print("Izin kamera ditolak");
      } else {
        print("Error: $e");
      }
      // Jika terjadi error dalam proses scanning, tampilkan dialog
      _showScanFailedDialog(context);
    } on FormatException {
      print("Scan dibatalkan oleh pengguna");
      // Jika pengguna membatalkan scan, tampilkan dialog
      _showScanFailedDialog(context);
    } catch (e) {
      print("Error: $e");
      // Jika terjadi error dalam proses scanning, tampilkan dialog
      _showScanFailedDialog(context);
    }
  }

  // Fungsi untuk menampilkan dialog ketika scan gagal atau dibatalkan
  void _showScanFailedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Scan Gagal'),
          content: Text('Silakan lakukan scan untuk melanjutkan.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> scanDataToApi(
    String trNumber,
    int userId,
    double lat,
    double long,
    int battery,
    String numberVehicle,
  ) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String bearerToken = prefs.getString('access_token') ?? '';
      print('Bearer Token: $bearerToken');

      final requestBody = json.encode({
        "tr_number": trNumber,
        "user_id": userId,
        "lat": lat.toString(),
        "long": long.toString(),
        "battery": battery.toString(),
        "number_vehicle": numberVehicle,
      });
      // print('User_Id: $userId');
      // print('Lat' + lat.toString());
      // print('Long' + long.toString());
      // print('Battery' + battery.toString());
      // print('Number_Vehicle' + numberVehicle.toString());

      // final requestBody = json.encode({
      //   "tr_number": "SHIP-2023731-00250",
      //   "user_id": 16,
      //   "lat": "-6.2576993",
      //   "long": "106.838343",
      //   "battery": "100",
      //   "number_vehicle": "H 3115 AWG"
      // });

      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.scanAssignDriver);

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $bearerToken',
      };

      var response = await http.post(url, headers: headers, body: requestBody);
      final jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('IDNYAAA: $userId');

      if (response.statusCode == 200) {
        scanModel = ScanModel.fromJson(jsonResponse);
        print('Response status: ${response.statusCode}');
        return;
      } else if (response.statusCode == 400 &&
          jsonResponse['message'] == 'Pengiriman Sedang Berlangsung') {
        _showOngoingDeliveryDialog();
      } else {
        // Handle other error cases
        _showErrorDialog();
      }
    } catch (error) {
      _showErrorDialog();
    }
  }

  void _showOngoingDeliveryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pengiriman Sedang Berlangsung'),
          content: Text(
              'Pengambilan data sedang dalam proses pengiriman. Silakan coba lagi nanti.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content:
              Text('Terjadi kesalahan saat mengambil data. Silakan coba lagi.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    manualBarcodeController
        .dispose(); // Hapus controller saat widget di-dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan Barcode Transaksi"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: manualBarcodeController,
              decoration: const InputDecoration(
                labelText: 'Barcode Manual',
                hintText: 'Masukkan barcode secara manual',
              ),
            ),
            SizedBox(height: 20),
            Text(
              scannedBarcode.isNotEmpty
                  ? "Hasil scan barcode: $scannedBarcode"
                  : "Hasil scan barcode akan muncul di sini",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String manualBarcode = manualBarcodeController.text;

                // if(scannedBarcode.isNotEmpty){
                //   scanDataToApi("", 24, -6.2576241, 106.8380971, 100, "B 1234 ABC");
                //   if (scanModel != null) {
                //     Navigator.pushReplacementNamed(context, '/transaction');
                //   } else {
                //     Navigator.pushNamed(context, '/barcode-scan');
                //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                //       content: Text("Nomor Transaksi Salah"),
                //       backgroundColor: Colors.redAccent,
                //       duration: Duration(seconds: 3),
                //     ));
                //   }
                // }

                if (manualBarcode.isNotEmpty) {
                  scanDataToApi(manualBarcode, 24, -6.2576241, 106.8380971, 100,
                      "B 1234 ABC");
                   _scanBarcode(context);
                // } else {
                //   Navigator.pop(context);
                //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                //     content: Text("Nomor Transaksi Salah"),
                //     backgroundColor: Colors.redAccent,
                //     duration: Duration(seconds: 3),
                //   ));
                }

                // if (scanModel != null) {
                //   Navigator.pushReplacementNamed(context, '/transaction');
                // } else {
                //   Navigator.pushNamed(context, '/barcode-scan');
                //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                //     content: Text("Nomor Transaksi Salah"),
                //     backgroundColor: Colors.redAccent,
                //     duration: Duration(seconds: 3),
                //   ));
                // }
              },
              child: const Text("Scan Barcode"),
            ),
          ],
        ),
      ),
    );
  }
}

//   String scannedBarcode = '';
//   String manualBarcode = '';
//
//   Future<void> _scanBarcode(BuildContext context) async {
//     if (manualBarcode.isEmpty) {
//       try {
//         ScanResult result = await BarcodeScanner.scan();
//         if (result.rawContent != null) {
//           String barcode = result.rawContent;
//           setState(() {
//             scannedBarcode = barcode;
//           });
//           print("Barcode: $barcode");
//           Navigator.pushReplacementNamed(context, '/transaction');
//         } else {
//           _showScanFailedDialog(context);
//         }
//       } on PlatformException catch (e) {
//         if (e.code == BarcodeScanner.cameraAccessDenied) {
//           print("Izin kamera ditolak");
//         } else {
//           print("Error: $e");
//         }
//         _showScanFailedDialog(context);
//       } on FormatException {
//         print("Scan dibatalkan oleh pengguna");
//         _showScanFailedDialog(context);
//       } catch (e) {
//         print("Error: $e");
//         _showScanFailedDialog(context);
//       }
//     } else {
//       print("Barcode manual: $manualBarcode");
//       setState(() {
//         scannedBarcode = manualBarcode;
//       });
//     }
//   }
//
//   void _showScanFailedDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Scan Gagal'),
//           content: Text('Silakan lakukan scan untuk melanjutkan.'),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/home');
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<ScanModel?> scanDataToApi(
//       String trNumber,
//       int userId,
//       double lat,
//       double long,
//       int battery,
//       String numberVehicle,
//       ) async {
//     try {
//       final SharedPreferences prefs = await SharedPreferences.getInstance();
//       final String bearerToken = prefs.getString('access_token') ?? '';
//       print('Bearer TokenNYA: $bearerToken');
//
//       final requestBody = json.encode({
//         "tr_number": trNumber,
//         "user_id": userId,
//         "lat": lat,
//         "long": long,
//         "battery": battery,
//         "number_vehicle": numberVehicle,
//       });
//
//       var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.scanAssignDriver);
//
//       var headers = {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $bearerToken',
//       };
//
//       var response = await http.post(url, headers: headers, body: requestBody);
//
//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//         ScanModel scanModel = ScanModel.fromJson(jsonResponse);
//         print('Response status: ${response.statusCode}');
//         return scanModel;
//
//       } else {
//         print('Gagal mengirim data ke API.');
//         print('Response status: ${response.statusCode}');
//         print('Response body: ${response.body}');
//         return null;
//       }
//     } catch (e) {
//       print(e.toString());
//       return null;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Scan Barcode Transaksi"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Center(
//               child: TextField(
//                 onChanged: (value) {
//                   setState(() {
//                     manualBarcode = value;
//                   });
//                 },
//                 decoration: const InputDecoration(
//                   labelText: 'Barcode Manual',
//                   hintText: 'Masukkan barcode secara manual',
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               scannedBarcode.isNotEmpty
//                   ? "Hasil scan barcode: $scannedBarcode"
//                   : "Hasil scan barcode akan muncul di sini",
//               style: TextStyle(fontSize: 16),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 await _scanBarcode(context);
//                 if (scannedBarcode.isNotEmpty) {
//                   final scanResult = await scanDataToApi(
//                     scannedBarcode,
//                     24,
//                     -6.2576241,
//                     106.8380971,
//                     100,
//                     "B 1234 ABC",
//                   );
//
//                   if (scanResult != null) {
//                     Navigator.pushReplacementNamed(context, '/transaction');
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                       content: Text("Gagal mengirim data ke API"),
//                       backgroundColor: Colors.redAccent,
//                       duration: Duration(seconds: 3),
//                     ));
//                   }
//                 }
//               },
//               child: const Text("Scan Barcode"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//   ScanModel? scanModel;
//   String scannedBarcode = '';
//   String manualBarcode = '';
//
//   Future<void> _scanBarcode(BuildContext context) async {
//     if (manualBarcode.isEmpty) {
//       try {
//         // Membaca kode barcode menggunakan plugin barcode_scan2
//         ScanResult result = await BarcodeScanner.scan();
//         if (result.rawContent != null) {
//           String barcode = result.rawContent;
//           setState(() {
//             scannedBarcode = barcode;
//           });
//           print("Barcode: $barcode");
//           // Setelah scan selesai, pindah ke halaman transaksi
//           Navigator.pushReplacementNamed(context, '/transaction');
//         } else {
//           // Jika pengguna membatalkan scan, tampilkan dialog
//           _showScanFailedDialog(context);
//         }
//       } on PlatformException catch (e) {
//         if (e.code == BarcodeScanner.cameraAccessDenied) {
//           print("Izin kamera ditolak");
//         } else {
//           print("Error: $e");
//         }
//         // Jika terjadi error dalam proses scanning, tampilkan dialog
//         _showScanFailedDialog(context);
//       } on FormatException {
//         print("Scan dibatalkan oleh pengguna");
//         // Jika pengguna membatalkan scan, tampilkan dialog
//         _showScanFailedDialog(context);
//       } catch (e) {
//         print("Error: $e");
//         // Jika terjadi error dalam proses scanning, tampilkan dialog
//         _showScanFailedDialog(context);
//       }
//     } else {
//       print("Barcode manual: $manualBarcode");
//       setState(() {
//         scannedBarcode = manualBarcode;
//       });
//     }
//
//     // if (scannedBarcode.isNotEmpty) {
//     //   final response = await scanDataToApi(
//     //     "SHIP-2023728-00023",
//     //     24,
//     //     0,
//     //     -6.2576241,
//     //     106.8380971,
//     //     100,
//     //     "B 1234 ABC",
//     //   );
//     //
//     //   if (response != null) {
//     //     Navigator.pushReplacement(
//     //       context,
//     //       MaterialPageRoute(
//     //         builder: (context) => TransactionPage(),
//     //       ),
//     //     );
//     //   } else {
//     //     // Handle error
//     //   }
//     // }
//
//   }
//
//   // Fungsi untuk menampilkan dialog ketika scan gagal atau dibatalkan
//   void _showScanFailedDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Scan Gagal'),
//           content: Text('Silakan lakukan scan untuk melanjutkan.'),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 // Navigator.pop(context); // Tutup dialog
//                 // Kembali ke halaman login
//                 Navigator.pushNamed(context, '/bottom-menu');
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<ScanModel?> scanDataToApi(
//     String trNumber,
//     int userId,
//     // int isFinished,
//     double lat,
//     double long,
//     int battery,
//     String numberVehicle,
//   ) async {
//     try {
//       final SharedPreferences prefs = await SharedPreferences.getInstance();
//       final String bearerToken = prefs.getString('access_token') ??
//           ''; // Get the token value correctly
//       print('Bearer Token: $bearerToken');
//
//
//       // await _scanBarcode(context);
//
//       final requestBody = json.encode({
//         "tr_number": trNumber,
//         "user_id": userId,
//         // "is_finished": isFinished,
//         "lat": lat,
//         "long": long,
//         "battery": battery,
//         "number_vehicle": numberVehicle
//       });
//
//       var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.scanAssignDriver);
//
//       var headers = {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $bearerToken'
//       };
//
//       var response = await http.post(url, headers: headers, body: requestBody);
//       print('Response status: ${response.statusCode}');
//       print('Response body: ${response.body}');
//       print(
//           'Response jsonResponse: ${ScanModel.fromJson(jsonDecode(response.body))}');
//
//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//         scanModel = ScanModel.fromJson(jsonResponse);
//         return scanModel;
//
//         // Navigator.pushNamed(context, '/transaction');
//       }
//         if(response.statusCode == 400) {
//           print('Data Tidak ada.');
//           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//             content: Text("Data Tidak Ada"),
//             backgroundColor: Colors.redAccent,
//             duration: Duration(seconds: 3),
//           ));
//           // Navigator.pushNamed(context, '/bottom-menu');
//           return null;
//
//         // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         //   content: Text("Data Success"),
//         //   backgroundColor: Colors.lightBlueAccent,
//         //   duration: Duration(seconds: 3),
//         // ));
//
//         } else {
//           print('Gagal mengirim data ke API.');
//           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//             content: Text("Data Failed"),
//             backgroundColor: Colors.redAccent,
//             duration: Duration(seconds: 3),
//           ));
//           // Navigator.pushNamed(context, '/bottom-menu');
//           return null;
//         }
//     } catch (e) {
//       print(e.toString());
//       return null;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Scan Barcode Transaksi"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Center(
//               child: TextField(
//                 onChanged: (value) {
//                   setState(() {
//                     manualBarcode = value;
//                   });
//                 },
//                 decoration: const InputDecoration(
//                   labelText: 'Barcode Manual',
//                   hintText: 'Masukkan barcode secara manual',
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               scannedBarcode.isNotEmpty
//                   ? "Hasil scan barcode: $scannedBarcode"
//                   : "Hasil scan barcode akan muncul di sini",
//               style: TextStyle(fontSize: 16),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                  _scanBarcode(context);
//
//                  if (scannedBarcode.isNotEmpty) {
//                    final response = await scanDataToApi(
//                      "SHIP-2023728-00023",
//                      24,
//                      // 1,
//                      -6.2576241,
//                      106.8380971,
//                      100,
//                      "B 1234 ABC",
//                    );
//
//                    if (response != null) {
//                      Navigator.pushReplacement(
//                        context,
//                        MaterialPageRoute(
//                          builder: (context) => TransactionPage(response: response),
//                        ),
//                      );
//                    } else {
//                      // Handle error
//                    }
//                  }
//
//
//
//                 // if (scannedBarcode.isNotEmpty) {
//                 //   scanDataToApi("SHIP-2023728-00023", 24, 0, -6.2576241,
//                 //       106.8380971, 100, "B 1234 ABC");
//                 //   if (scanModel != null) {
//                 //     Navigator.pushReplacementNamed(context, '/transaction');
//                 //   } else {
//                 //     Navigator.pushNamed(context, '/bottom-menu');
//                 //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                 //       content: Text("Nomor Transaksi Salah"),
//                 //       backgroundColor: Colors.redAccent,
//                 //       duration: Duration(seconds: 3),
//                 //     ));
//                 //   }
//                 // }
//               },
//               child: const Text("Scan Barcode"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
