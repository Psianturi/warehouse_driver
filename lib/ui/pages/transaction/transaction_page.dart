import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman Transaksi'),
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
                const SizedBox(height: 30),
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
                const SizedBox(height: 40),

                ElevatedButton(onPressed:
                () {
                  Navigator.pushNamed(context, '/bottom-menu',
                  );
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(
                  //   content: Text("Scan Kembali untuk menyelesaikan transaksi"),
                  //   backgroundColor: Colors.blueAccent,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.all(Radius.circular(22)),
                  //   ),
                  //   showCloseIcon: true,
                  //   duration: Duration(seconds: 5),
                  // ));

                },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.orangeAccent,
                    shadowColor: Colors.greenAccent,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text('Kembali ke Beranda'),
                ),

                const SizedBox(height: 20),


              ],
            ),
          )),

    );
  }
}
