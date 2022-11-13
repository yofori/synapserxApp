import 'package:flutter/material.dart';
import 'package:synapserx_prescriber/common/auth.dart';
import 'package:synapserx_prescriber/common/service.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  ChangePasswordPageState createState() => ChangePasswordPageState();
}

class ChangePasswordPageState extends State<ChangePasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  final DioClient _dioClient = DioClient();
  @override
  Widget build(BuildContext context) {
    bool changedPassword;
    return Scaffold(
      appBar: AppBar(title: const Text('Change Password')),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Current Password:',
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (val) {
                    if (val != GlobalData.password) {
                      return "Invalid Current Password";
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your Current Password',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('New Password:'),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: passwordController,
                  validator: (val) {
                    // ignore: prefer_is_not_empty
                    if ((val!.isEmpty) ||
                        !RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                            .hasMatch(val)) {
                      return "Password does not meet the minimum requirements";
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your New Password',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('Confirm New Password:'),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (val) {
                    if (val != passwordController.text) {
                      return "Passwords don't match";
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm your New Password',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () async => {
                          if (_formKey.currentState!.validate())
                            {
                              changedPassword = await _dioClient
                                  .changePassword(passwordController.text),
                              if (changedPassword)
                                {
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.green.shade300,
                                        content: const Text(
                                            'Your password has been changed'),
                                      ),
                                    ),
                                    Navigator.pushReplacementNamed(context, '/')
                                  }
                                }
                              else
                                {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red.shade300,
                                      content: const Text(
                                          'Password could not be changed'),
                                    ),
                                  ),
                                }
                            }
                        },
                    child: const Text(
                      'SUBMIT',
                      style: TextStyle(fontSize: 18),
                    ))
              ],
            )),
          )),
    );
  }
}
