
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:jti_warehouse_driver/api/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {

  Future<void> _scanBarcode(BuildContext context) async {
    try {
      // Membaca kode barcode menggunakan plugin barcode_scan2
      ScanResult result = await BarcodeScanner.scan();
      if (result.rawContent != null) {
        String barcode = result.rawContent;
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


  Future<void> sendScanDataToApi(
      String tr_number, int user_id, bool isFinished, double lat, double long, token) async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('token', token);
    _scanBarcode(context);

    try {
    // Menyimpan token menggunakan shared_preferences
    //   prefs.setString('token', token);
    final requestData = json.encode({
      "tr_number": "SHIP-2023728-00023",
      "user_id": user_id,
      "is_finished": isFinished,
      "lat": lat,
      "long": long,
    });

    final http.Response response = await http.post(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.scanAssignDriver),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: requestData,
    );

    try {
      if (kDebugMode) {
        print(jsonDecode(response.body.toString()));
      }

      if (response.statusCode == 200) {
        print("Data berhasil dikirim ke API dengan status code: ${response.statusCode}");
      } else {
        print("Gagal mengirim data ke API. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print(e.toString());
    }
    } catch (e) {
      print(e.toString());
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
            Text(
                "Hasil scan barcode akan muncul di sini",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed:  () {
                sendScanDataToApi("tr_number" , 1, false, -6.2576241, 106.8380971, "token");
                Navigator.pushNamed(context, '/bottom-menu');
              },
              child: Text("Scan Barcode"),
            ),
          ],
        ),
      ),
    );
  }
}