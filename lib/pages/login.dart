import 'package:flutter/material.dart';
import 'package:synapserx_prescriber/main.dart';
import 'package:synapserx_prescriber/pages/register.dart';
import 'package:synapserx_prescriber/common/auth.dart';
import 'package:synapserx_prescriber/pages/forgotten_password.dart';
import 'package:synapserx_prescriber/pages/widgets/loadingindicator.dart';
import 'homepage.dart';

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
      LoadingIndicatorDialog().show(context, 'Signing in ......');
      int res = await _dioClient.loginUser(
        nameController.text.trim(),
        passwordController.text,
      );
      LoadingIndicatorDialog().dismiss();

      ScaffoldMessenger.of(navigatorKey.currentContext!).hideCurrentSnackBar();

      if (res == 1) {
        Navigator.pushReplacement(navigatorKey.currentContext!,
            MaterialPageRoute(builder: (context) => const HomePage()));
        scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: const Text('login successful'),
          backgroundColor: Colors.green.shade300,
        ));
      } else if (res == 2) {
        Navigator.pushReplacement(navigatorKey.currentContext!,
            MaterialPageRoute(builder: (context) => const HomePage()));
        scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
          content: Text('Server is unreachable. Offline authentication done'),
          backgroundColor: Color.fromARGB(255, 218, 152, 67),
        ));
      } else {
        scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
          content: const Text(
              'Error: Login unsuccessful, check user name and password'),
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
                child: Center(
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
                          margin: const EdgeInsets.fromLTRB(25, 10, 25, 10),
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
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                              const Text('Do not have an account?'),
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
                  ),
                ))));
  }
}
