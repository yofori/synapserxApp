import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:synapserx_prescriber/pages/register.dart';
import 'package:synapserx_prescriber/common/dio_client.dart';
import 'package:synapserx_prescriber/pages/forgotten_password.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'homepage.dart';
import 'package:synapserx_prescriber/common/service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final DioClient _dioClient = DioClient();
  bool _showPassword = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('logging in......'),
          backgroundColor: Color.fromARGB(255, 72, 160, 231),
          duration: Duration(seconds: 2)));

      dynamic res = await _dioClient.loginUser(
        nameController.text.trim(),
        passwordController.text,
      );

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (res['ErrorCode'] == null) {
        String accessToken = res['token'];
        String refreshToken = res['refreshtoken'];
        String username = res['username'];
        GlobalData.accessToken = accessToken;
        GlobalData.refreshToken = refreshToken;
        GlobalData.username = username;
        GlobalData.password = passwordController.text;
        String fullname = res['firstname'] + ' ' + res['surname'];
        String mdcregno = res['mdcregno'];
        const storage = FlutterSecureStorage();
        await storage.write(key: "token", value: accessToken);
        await storage.write(key: "refreshtoken", value: refreshToken);
        await storage.write(key: "fullname", value: fullname);
        await storage.write(key: "mdcregno", value: mdcregno);
        await storage.write(key: "username", value: username);
        await storage.write(key: "password", value: passwordController.text);
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('login successful'),
          backgroundColor: Colors.green.shade300,
        ));
      } else {
        // ignore: use_build_context_synchronously
        log('Error Logging in');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${res['Message']}'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
            body: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(children: [
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          'SynapseRX',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                              fontSize: 30),
                        )),
                    Container(
                        margin: const EdgeInsets.fromLTRB(25, 50, 25, 10),
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10),
                                child: const Text(
                                  'Sign in',
                                  style: TextStyle(fontSize: 20),
                                )),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                controller: nameController,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Please enter your username";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'User Name',
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: TextFormField(
                                obscureText: _showPassword,
                                controller: passwordController,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Please enter your password";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText: 'Password',
                                    hintText: 'Enter your password here',
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _showPassword = !_showPassword;
                                        });
                                      },
                                      child: Icon(
                                        _showPassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.grey,
                                      ),
                                    )),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                //forgot password screen
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgotPasswordPage()));
                              },
                              child: const Text(
                                'Forgot Password?',
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                                height: 50,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: ElevatedButton(
                                    onPressed: login,
                                    style: ElevatedButton.styleFrom(
                                        //primary: Colors.indigo,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40, vertical: 10)),
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 20,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                    ))),
                            const SizedBox(height: 15),
                            const Text('Do not have account?'),
                            const SizedBox(height: 1),
                            TextButton(
                              child: const Text(
                                'Create an account',
                                style: TextStyle(fontSize: 16),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterPage()));
                              },
                            )
                          ],
                        ))
                  ]),
                ))));
  }
}
