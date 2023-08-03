// import 'package:flutter/material.dart';
// import 'package:barcode_scan2/barcode_scan2.dart';
// import 'package:flutter/services.dart';
//
// class ScanPage extends StatelessWidget {
//   const ScanPage({super.key});
//
//   Future<void> _scanBarcode(BuildContext context) async {
//     try {
//       // Membaca kode barcode menggunakan plugin barcode_scan2
//       ScanResult result = await BarcodeScanner.scan();
//       String barcode = result.rawContent;
//       print("Barcode: $barcode");
//
//       // Jika berhasil, pindah ke halaman bottom menu
//       Navigator.pushReplacementNamed(context, '/bottom-menu');
//     } on PlatformException catch (e) {
//       if (e.code == BarcodeScanner.cameraAccessDenied) {
//         print("Izin kamera ditolak");
//       } else {
//         print("Error: $e");
//       }
//       // Jika terjadi error atau pengguna membatalkan scan, kembali ke halaman login
//       _showScanFailedDialog(context);
//     } on FormatException {
//       print("Scan dibatalkan oleh pengguna");
//       // Jika terjadi error atau pengguna membatalkan scan, kembali ke halaman login
//       _showScanFailedDialog(context);
//     } catch (e) {
//       print("Error: $e");
//       // Jika terjadi error atau pengguna membatalkan scan, kembali ke halaman login
//       _showScanFailedDialog(context);
//     }
//   }
//
//   // Fungsi untuk menampilkan dialog ketika scan gagal atau dibatalkan
//   void _showScanFailedDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Scan Gagal'),
//           content: const Text('Silakan lakukan scan untuk melanjutkan.'),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context); // Tutup dialog
//                 Navigator.pushNamed(context, '/login');// Kembali ke halaman login
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Scan Page'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () => _scanBarcode(context),
//           child: Text('Scan Barcode'),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  Future<void> _scanBarcode(BuildContext context) async {
    try {
      // Membaca kode barcode menggunakan plugin barcode_scan2
      ScanResult result = await BarcodeScanner.scan();
      if (result.rawContent != null) {
        String barcode = result.rawContent;
        print("Barcode: $barcode");

        // Setelah scan selesai, pindah ke halaman transaksi
        Navigator.pushReplacementNamed(context, '/bottom-menu');
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
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _scanBarcode(context),
          child: const Text('Scan Barcode Disini'),
        ),
      ),
    );
  }
}
