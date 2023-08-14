import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jti_warehouse_driver/api/constant.dart';
import 'package:jti_warehouse_driver/api/key.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final String loggedInUserId = "your_logged_in_user_id";

  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    fetchHistoryData( 1);
  }

  Future<void> fetchHistoryData(user_id) async {
    var url = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.getTransactionHistory + user_id.toString());
    final response = await http.get(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken'
        });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      print('History Data Sukses diakses: $responseData');

      if (responseData.containsKey('data')) {
        final List<dynamic> data = responseData['data'];

        transactions = data.map((transactionData) {
          return Transaction(
            trNumber: transactionData['tr_number'],
            transactionData: transactionData['transaction'],
            user: transactionData['user'],
            status: transactionData['status'],
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
    return  Scaffold(
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
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          final transactionData = transaction.transactionData;
          final productName = transactionData['product']['name'];
          final sendAt = transactionData['send_at'];

          return Card(
            child: ListTile(
              title: Text(productName),
              subtitle: Text('Sent at: $sendAt'),
              trailing: Text(transaction.status),
              onTap: () {
                // Add your action when a transaction is tapped
              },
            ),
          );
        },
      ),


      // body: Card(
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children: <Widget>[
      //       const ListTile(
      //         leading: Icon(Icons.album),
      //         title: Text('Transaksi Driver'),
      //         subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
      //       ),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.end,
      //         children: <Widget>[
      //           TextButton(
      //             child: const Text('INFO'),
      //             onPressed: () {/* ... */},
      //           ),
      //           const SizedBox(width: 8),
      //           TextButton(
      //             child: const Text('DETAIL'),
      //             onPressed: () {/* ... */},
      //           ),
      //           const SizedBox(width: 8),
      //         ],
      //       ),
      //     ],
      //   ),
      // )

    );
  }
}

class Transaction {
  final String trNumber;
  final Map<String, dynamic> transactionData;
  final Map<String, dynamic> user;
  final String status;

  Transaction({
    required this.trNumber,
    required this.transactionData,
    required this.user,
    required this.status,
  });
}