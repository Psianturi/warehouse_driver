import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jti_warehouse_driver/api/constant.dart';
import 'package:jti_warehouse_driver/api/key.dart';
import 'package:jti_warehouse_driver/ui/pages/models/history_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';


class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // final String loggedInUserId = "user_id";
  late int loggedInUserId;
  List<Transaction> transaction = [];

  void loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedInUserId = prefs.getInt('id') ?? 0; // Gunakan default value jika tidak ditemukan
    });
    fetchHistoryData(loggedInUserId);
  }

  @override
  void initState() {
    super.initState();
    loadUserId();
  }

  Future<void> fetchHistoryData(userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String bearerToken = prefs.getString('access_token') ?? '';

    var url = Uri.parse(ApiConstants.baseUrl +
        ApiConstants.getTransactionHistory +
        userId.toString());
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    });
    print('Response status Token: $bearerToken');
    print('Response userID: $userId');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      print('History Data Sukses diakses: $responseData');

      if (responseData.containsKey('data')) {
        final List<dynamic> data = responseData['data'];

        transaction = data.map((transactionData) {
          return Transaction(
            trNumber: transactionData['tr_number'],
            status: transactionData['status'],
            sendAt: transactionData['send_at'],
            receiveAt: transactionData['receive_at'],
            productName: transactionData['product_name'],
            quantity: transactionData['quantity'],
            // product: Product(
            //   id: transactionData['product']['id'],
            //   name: transactionData['product']['name'],
            //   priceBuy: transactionData['product']['price_buy'],
            //   priceSale: transactionData['product']['price_sale'],
            //   createdAt: transactionData['product']['created_at'],
            //   updatedAt: transactionData['product']['updated_at'],
            // ),
            transactionData: transactionData,
            // product: transactionData['product'],
          );
        }).toList();

        setState(() {});
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.orangeAccent,
        automaticallyImplyLeading: false,
        // actions: [
        //
        // ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
      ),
      body: AnimationLimiter(
    child:
      ListView.builder(
        itemCount: transaction.length,
        // itemCount: products.length,

        itemBuilder: (context, index) {
          // final Transaction transactionData = transaction[index];
          // final String? trNumber =  transactionData.trNumber;
          // final String? status = transactionData.status;
          final String? productName = transaction[index].productName;
          final String? trNumber = transaction[index].trNumber;
          final String? status = transaction[index].status;
          final String? sendAt = transaction[index].sendAt;
          final String? receiveAt = transaction[index].receiveAt;
          final int? quantity = transaction[index].quantity;

          print('Transaction Data2: $trNumber');
          print('Transaction Data3: $productName');
          print('Transaction Data4: $status');
          print('Transaction Data5: $sendAt');
          print('Transaction Data6: $receiveAt');
          print('Transaction Data8: $quantity');

          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: Card(
                  elevation: 2.0,
                  child: ListTile(
                    title: Text('Product: $productName'),
                    subtitle: Text('Transaction Number: $trNumber'),
                    trailing: Text('Status: $status'),
                    onTap: () {
                      // Add your action when a transaction is tapped
                    },
                  ),
                ),
              ),
            ),
          );


          // return Card(
          //   child: ListTile(
          //     title: Text('Product: $productName'),
          //     subtitle: Text('Transaction Number: $trNumber'),
          //     trailing: Text('Status: $status'),
          //     onTap: () {
          //       // Add your action when a transaction is tapped
          //     },
          //   ),
          // );
        },
      ),
      ),

    );
  }
}

// class Transaction {
//   final String trNumber;
//   final Map<String, dynamic> transactionData;
//   final Map<String, dynamic> user;
//   final String status;
//
//   Transaction({
//     required this.trNumber,
//     required this.transactionData,
//     required this.user,
//     required this.status,
//   });
// }
