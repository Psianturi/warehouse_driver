
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jti_warehouse_driver/api/constant.dart';
import 'package:jti_warehouse_driver/api/key.dart';
import 'package:jti_warehouse_driver/ui/pages/models/scan_model.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  ScanResponseModel? scanModel;
  String scannedBarcode = '';
  String manualBarcode = '';

  Future<void> _scanBarcode(BuildContext context) async {
    if (manualBarcode.isEmpty) {
      try {
        // Membaca kode barcode menggunakan plugin barcode_scan2
        ScanResult result = await BarcodeScanner.scan();
        if (result.rawContent != null) {
          String barcode = result.rawContent;
          setState(() {
            scannedBarcode = barcode;
          });
          print("Barcode: $barcode");
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
    } else {
      print("Barcode manual: $manualBarcode");
      setState(() {
        scannedBarcode = manualBarcode;
      });
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
                // Navigator.pop(context); // Tutup dialog
                // Kembali ke halaman login
                Navigator.pushNamed(context, '/home');
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
       int isFinished,
       double lat,
       double long,
      ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', HttpHeaders.proxyAuthorizationHeader);

    // const String trNumber = "SHIP-2023728-00035";
    // final int userId = 24;
    // final int isFinished = 0;
    // final double lat = -6.2576241;
    // final double long = 106.8380971;
    _scanBarcode(context);
    final requestBody = json.encode(
        {
          "tr_number": trNumber,
              "user_id": userId,
              "is_finished": isFinished,
              "lat": lat,
              "long": long,
        });

    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.scanAssignDriver);

    var headers = { 'Content-Type': 'application/json',
      'Authorization':
    'Bearer $bearerToken' };

    var response = await http.post(url, headers: headers, body: requestBody);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    print('Response jsonResponse: ${ScanResponseModel.fromJson(jsonDecode(response.body))}');

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Data Success"),
        backgroundColor: Colors.lightBlueAccent,
        duration: Duration(seconds: 2),
      ));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        scanModel = ScanResponseModel.fromJson(jsonResponse);
        Navigator.pushNamed(context, '/transaction');
      } else {
        print('Gagal mengirim data ke API.');
        Navigator.pushNamed(context, '/home');
      }

    }
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
            Center(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  manualBarcode = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Barcode Manual',
                hintText: 'Masukkan barcode secara manual',
              ),
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
              onPressed:  () {
                scanDataToApi(
                  "SHIP-2023728-00035",
                  24,
                  0,
                  -6.2576241,
                  106.8380971,);
                if (scanModel != null) {
                  Navigator.pushReplacementNamed(context, '/transaction');
                } else {
                  Navigator.pushNamed(context, '/bottom-menu');
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Nomor Transaksi Salah"),
                    backgroundColor: Colors.redAccent,
                    duration: Duration(seconds: 3),
                  ));
                }

              },
              child: const Text("Scan Barcode"),
            ),
          ],
        ),
      ),
    );
  }
}