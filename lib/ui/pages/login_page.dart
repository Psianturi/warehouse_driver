import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jti_warehouse_driver/api/constant.dart';
import 'package:jti_warehouse_driver/widgets/buttons.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  var emailController = TextEditingController(text: "posmcoba@gmail.com");
  TextEditingController passwordController = TextEditingController(text: "12345");

  late final String title;

  // Future<void> login(String email, String password) async {
  //   try {
  //     final requestBody = json.encode({
  //       'email': email,
  //       'password': password,
  //     });
  //
  //     final response = await post(
  //       Uri.parse(ApiConstants.baseUrl + ApiConstants.loginEndPoint),
  //       headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  //       body: requestBody,
  //     );
  //
  //
  //     final int userId = json.decode(response.body)['data']['user']['id'];
  //
  //     if (response.statusCode == 200) {
  //       final jsonResponse = json.decode(response.body);
  //
  //       // Extract and store the access token
  //       final accessToken = jsonResponse['data']['access_token'];
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       prefs.setString('access_token', accessToken);
  //
  //       prefs.setInt('id',userId );
  //
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text("Login Success"),
  //         backgroundColor: Colors.lightBlueAccent,
  //         duration: Duration(seconds: 1),
  //       ));
  //
  //       if (prefs.containsKey('id')) {
  //         print('****user_id nyahh*** : ${prefs.getInt('id')}');
  //       } else {
  //         print('uid: null');
  //       }
  //
  //       Navigator.pushNamed(context, '/bottom-menu');
  //     } else {
  //       final jsonResponse = json.decode(response.body); // Define jsonResponse here
  //       final errorMessage = jsonResponse['meta']['message'] ?? 'Login Failed';
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text(errorMessage),
  //         backgroundColor: Colors.redAccent,
  //         duration: Duration(seconds: 3),
  //       ));
  //     }
  //
  //   } catch (e) {
  //     // Handle exceptions, such as network errors
  //     print('Error: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('An error occurred'),
  //       backgroundColor: Colors.redAccent,
  //       duration: Duration(seconds: 3),
  //     ));
  //   }
  // }


  Future <void> login(
      String email,
      password,
      // token
      ) async {

    try {

      final myBody = json.encode({
        'email': email,
        'password': password,
      });

      Response response = await post(
          Uri.parse(ApiConstants.baseUrl + ApiConstants.loginEndPoint ),
          headers: {HttpHeaders.contentTypeHeader: 'application/json',
          },
          body: myBody);

        try {
          final int userId = json.decode(response.body)['data']['user']['id'];
          final accessToken = json.decode(response.body)['data']['access_token'];

        if (response.statusCode == 200) {
          print('ResponseStatus Login: ${response.statusCode}');
          print('ResponseBody Login: ${response.body}');
          // Save user_id to SharedPreferences,

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setInt('id',userId );
          prefs.setString('access_token', accessToken);

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Login Success"),
            backgroundColor: Colors.lightBlueAccent,
            duration: Duration(seconds: 1),
          ));

          if (prefs.containsKey('id')) {
            print('****user_id nyahh*** : ${prefs.getInt('id')}');
          } else {
            print('uid: null');
          }


          if (response.statusCode == 200) {
            Navigator.pushNamed(context, '/bottom-menu');
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
          horizontal: 40,
        ),
        children: [
          Container(
            height: 190,
            margin: const EdgeInsets.only(
              top: 40,
              bottom: 15,
            ),

            child: Image.asset(
              'assets/images/logoJTI.png',
              fit: BoxFit.fitWidth,
            ),
          ),

          const Text(
            'Driver App Warehouse',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Color(0xff1D1E3C),

            ),
          ),
          SizedBox(height: 130,
              child: Lottie.asset("assets/anims/truck_driver.json")),

          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NOTE: EMAIL INPUT
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email Address',
                      hintText: 'email'),
                ),

                const SizedBox(
                  height: 16,
                ),
                // NOTE: PASSWORD INPUT
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'password'),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                      'Forgot Password',
                      style: TextStyle(
                        color: Colors.blue,
                      )
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomFilledButton(
                  title: 'Sign In',
                  onPressed: () async {
                    // SharedPreferences pref = await SharedPreferences.getInstance();
                    // pref.setString("", "");


                    login(emailController.text.toString(),
                        passwordController.text.toString()
                    );

                    if (emailController.text.isEmpty ||
                        passwordController.text.isEmpty) {
                      print('email or password is empty');
                    } else {
                      print('email OK');
                    }

                    // Navigator.push(context,
                        // MaterialPageRoute(builder:(context) => const HomePage() ) );
                    // Navigator.pushNamed(context, '/barcode-scan');

                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomTextButton(
            title: 'Create New Account',
            onPressed: () {
              Navigator.pushNamed(context, '/sign-up');
            },
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );

  }
}

