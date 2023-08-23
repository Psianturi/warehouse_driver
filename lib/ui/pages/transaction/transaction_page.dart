import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:jti_warehouse_driver/ui/pages/models/scan_model.dart';

class TransactionPage extends StatelessWidget {
  final ScanModel? scanModel;

  TransactionPage({Key? key, required this.scanModel}) : super(key: key);
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Transaksi'),
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
          child: Center(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 18),
                // Display Meta Data
                if (scanModel != null && scanModel!.meta != null)
                  Container(
                    transform: Matrix4.translationValues(1.0, -2.0, 1.0),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 6),
                        const Center(
                         child: Text(
                          "Meta Data",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ),
                        const SizedBox(height: 4),
                        FormBuilderTextField(
                          name: 'code',
                          textInputAction: TextInputAction.next,
                          decoration:
                              const InputDecoration(labelText: 'No Code'),
                          initialValue: '${scanModel!.meta!.code}',
                          readOnly: true,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                        ),
                        const SizedBox(height: 7),
                        FormBuilderTextField(
                          name: 'status',
                          textInputAction: TextInputAction.next,
                          decoration:
                              const InputDecoration(labelText: 'Status'),
                          initialValue: '${scanModel!.meta!.status}',
                          readOnly: true,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                        ),
                        FormBuilderTextField(
                          name: 'message',
                          textInputAction: TextInputAction.next,
                          decoration:
                              const InputDecoration(labelText: 'Message'),
                          initialValue: '${scanModel!.meta!.message}',
                          readOnly: true,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),

                // Display Data
                if (scanModel != null && scanModel!.data != null)
                  Container(
                    transform: Matrix4.translationValues(1.0, -2.0, 1.0),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        const Center(
                        child: Text(
                          "Data",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ),
                        const SizedBox(height: 4),
                        for (Data data in scanModel!.data!)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text("ID: ${data.id}"),
                              // SizedBox(height: 5),
                              // Text("Tanggal: ${data.lastDate}"),
                              FormBuilderTextField(
                                name: 'idnya',
                                textInputAction: TextInputAction.next,
                                decoration:
                                    const InputDecoration(labelText: 'No ID'),
                                initialValue: '${data.id}',
                                readOnly: true,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                              ),
                              const SizedBox(height: 7),
                              FormBuilderTextField(
                                name: 'trNumber',
                                textInputAction: TextInputAction.next,
                                decoration:
                                const InputDecoration(labelText: 'Transaction Number'),
                                initialValue: '${data.idTrackDriver!.trNumber}',
                                readOnly: true,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                              ),
                              const SizedBox(height: 7),
                              FormBuilderTextField(
                                name: 'lastDate',
                                textInputAction: TextInputAction.next,
                                decoration:
                                    const InputDecoration(labelText: 'Tanggal'),
                                initialValue: '${data.lastDate}',
                                readOnly: true,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                              ),
                              SizedBox(height: 5),
                            ],
                          ),
                      ],
                    ),
                  ),

                const SizedBox(height: 38),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/bottom-menu');
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.orangeAccent,
                    shadowColor: Colors.greenAccent,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text('Ke Detail Transaksi'),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class TransactionPage extends StatefulWidget {
//   const TransactionPage({super.key, required response});
//
//   @override
//   State<TransactionPage> createState() => _TransactionPageState();
// }
//
// class _TransactionPageState extends State<TransactionPage> {
//   bool autoValidate = true;
//   bool readOnly = false;
//   bool showSegmentedControl = true;
//   final _formKey = GlobalKey<FormBuilderState>();
//
//   ScanModel? response;
//
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Transaction Page"),
// //       ),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           crossAxisAlignment: CrossAxisAlignment.center,
// //           children: [
// //             Text("Transaction Data:"),
// //             Text("Status: ${response?.meta?.status ?? ''}"),
// //             // ... extract and display more data as needed ...
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Halaman Transaksi'),
//         titleTextStyle: const TextStyle(
//           color: Colors.white,
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//         ),
//         backgroundColor: Colors.orangeAccent,
//         automaticallyImplyLeading: false,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             bottom: Radius.circular(25),
//           ),
//         ),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(14),
//         children: <Widget>[
//           const SizedBox(height: 30),
//           FormBuilderTextField(
//             name: 'from',
//             textInputAction: TextInputAction.next,
//             decoration: const InputDecoration(labelText: 'Pengiriman Dari'),
//             initialValue: '${response ?? ''}',
//             readOnly: true,
//             validator: FormBuilderValidators.compose([
//               FormBuilderValidators.required(),
//             ]),
//           ),
//           const SizedBox(height: 7),
//           FormBuilderTextField(
//             name: 'to',
//             textInputAction: TextInputAction.next,
//             decoration: const InputDecoration(labelText: 'Tujuan Pengiriman'),
//             initialValue: 'Warehouse Bojonegara',
//             readOnly: true,
//             validator: FormBuilderValidators.compose([
//               FormBuilderValidators.required(),
//             ]),
//           ),

//           const SizedBox(height: 40),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pushNamed(context, '/bottom-menu');
//             },
//             style: ElevatedButton.styleFrom(
//               foregroundColor: Colors.orangeAccent,
//               shadowColor: Colors.greenAccent,
//               backgroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30.0),
//               ),
//             ),
//             child: const Text('Kembali ke Beranda'),
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }
