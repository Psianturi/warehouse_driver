import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:jti_warehouse_driver/api/constant.dart';
import 'package:jti_warehouse_driver/ui/pages/home_page.dart';
import 'package:jti_warehouse_driver/widgets/buttons.dart';
import 'package:jti_warehouse_driver/widgets/forms.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController(text: '');
  final emailController = TextEditingController(text: '');
  final passwordController = TextEditingController(text: '');
  final phoneController = TextEditingController(text: '');

  bool validate() {
    print(nameController.text);

    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      return false;
    }

    return true;
  }

  void signUpDriver(
      String fullname,
      email,
      phonenumber,
      password,
      ) async {
    try {
      final myBody = json.encode({
        'name': fullname,
        'email': email,
        'phone': phonenumber,
        'password': password,
      });

      Response response = await post(
          Uri.parse(ApiConstants.baseUrl + ApiConstants.registerEndPoint),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
          body: myBody);

      try {
        print(jsonDecode(response.body.toString()));
        if (response.statusCode == 200) {
          print('Response SignUp: ${response.statusCode}');

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("account is created successfully"),
            backgroundColor: Colors.greenAccent,
            duration: Duration(seconds: 2),
          ));

          if (response.statusCode == 200) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) =>  HomePage()));
          } else {
            print('failed');
          }
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
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        children: [
          Container(
            width: 155,
            height: 50,
            margin: const EdgeInsets.only(
              top: 30,
              bottom: 80,
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/img_logo_light.png',
                ),
              ),
            ),
          ),
          const Text(
            'Daftar Dahulu, \nUntuk Melanjutkan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NOTE: NAME INPUT
                CustomFormField(
                  title: 'Full Name',
                  controller: nameController,
                ),
                const SizedBox(
                  height: 16,
                ),
                // NOTE: EMAIL INPUT
                CustomFormField(
                  title: 'Email Address',
                  controller: emailController,
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomFormField(
                  title: 'phone number',
                  controller: phoneController,
                ),
                const SizedBox(
                  height: 16,
                ),
                // NOTE: PASSWORD INPUT
                CustomFormField(
                  title: 'Password',
                  obscureText: true,
                  controller: passwordController,
                ),
                // add photo profile ui here with multipart


                const SizedBox(
                  height: 30,
                ),

              ],
            ),
          ),
          CustomFilledButton(
            onPressed: () {
              signUpDriver(
                nameController.text.toString(),
                emailController.text.toString(),
                phoneController.text.toString(),
                passwordController.text.toString(),
              );
              Navigator.pushNamed(context, '/home');
            },
            title: 'Sign Up',

          ),

          const SizedBox(
            height: 50,
          ),
          CustomTextButton(
            title: 'Sign In',
            onPressed: () {
              Navigator.pushNamed(context, '/sign-in');
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.06,
          ),
        ],
      ),
    );
  }
}
