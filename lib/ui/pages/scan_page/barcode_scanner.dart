import 'dart:io';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jti_warehouse_driver/api/constant.dart';
import 'package:jti_warehouse_driver/ui/pages/models/scan_model.dart';
import 'package:jti_warehouse_driver/ui/pages/transaction/transaction_page.dart';
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionPage(scanModel: scanModel),
          ));

      } else if (response.statusCode == 400 &&
          jsonResponse['message'] == 'Pengiriman Sedang Berlangsung') {
        _showOngoingDeliveryDialog();
      } else {
        // Handle other error cases
        _showErrorDialog();
        return;
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
                if (scanModel != null) {
                  print("Meta Code: ${scanModel?.meta?.code}");
                  print("Meta Status: ${scanModel?.meta?.status}");
                  print("Meta Message: ${scanModel?.meta?.message}");
                  print("Is Paginated: ${scanModel?.meta?.isPaginated}");
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
