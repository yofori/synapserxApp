import 'package:flutter/material.dart';
import 'package:synapserx_prescriber/common/dio_client.dart';
import 'package:synapserx_prescriber/models/user.dart';

import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController mdcregnoController = TextEditingController();
  final DioClient _dioClient = DioClient();
  bool _showPassword = true;
  bool checkboxValue = false;
  String dropdownvalue = 'Dr';
  var items = [
    'Dr',
    'Prof',
    'Pharm',
  ];

  Future<void> registerUser() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Processing Data'),
        backgroundColor: Colors.green.shade300,
      ));

      User user = User(
        email: emailController.text,
        password: passwordController.text,
        username: usernameController.text,
        prescriberMDCRegNo: mdcregnoController.text,
        firstname: firstnameController.text,
        surname: surnameController.text,
        telephoneNo: telephoneController.text,
        title: dropdownvalue,
        role: 'Basic',
        id: 'placeholder',
      );

      dynamic res = await _dioClient.createUser(user: user);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (res['ErrorCode'] == null) {
        // ignore: use_build_context_synchronously
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${res['Message']}'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: (const Text('SynapseRx - Create Account'))),
        body: SingleChildScrollView(
            child: Stack(children: [
          const SizedBox(
            height: 150,
          ),
          Container(
              margin: const EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(children: [
                      GestureDetector(
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border:
                                    Border.all(width: 5, color: Colors.white),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 20,
                                    offset: Offset(5, 5),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.person,
                                color: Colors.grey.shade300,
                                size: 80.0,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(80, 80, 0, 0),
                              child: Icon(
                                Icons.add_circle,
                                color: Colors.grey.shade700,
                                size: 25.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Title',
                              hintText: 'Enter your title'),
                          value: dropdownvalue,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: items.map((String items) {
                            return DropdownMenuItem(
                                value: items, child: Text(items));
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              dropdownvalue = newValue.toString();
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Surname',
                            hintText: 'Enter your Surname'),
                        controller: surnameController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'First Name',
                            hintText: 'Enter your first name'),
                        controller: firstnameController,
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                            hintText: 'Enter your email address'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          // ignore: prefer_is_not_empty
                          if (!(val!.isEmpty) &&
                              !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                  .hasMatch(val)) {
                            return "Enter a valid email address";
                          }
                          return null;
                        },
                        controller: emailController,
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'MDC Reg No',
                            hintText: 'Enter your MDC Reg No'),
                        validator: (val) {
                          if ((val!.isEmpty)) {
                            return "Enter a MDC Registration Number";
                          }
                          return null;
                        },
                        controller: mdcregnoController,
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Cell Phone Number',
                            hintText: 'Enter your cellphone number'),
                        keyboardType: TextInputType.phone,
                        validator: (val) {
                          if (!(val!.isEmpty) &&
                              !RegExp(r"^(\d+)*$").hasMatch(val)) {
                            return "Enter a valid phone number";
                          }
                          return null;
                        },
                        controller: telephoneController,
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Username',
                            hintText: 'Enter your username'),
                        obscureText: false,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please enter your username";
                          }
                          return null;
                        },
                        controller: usernameController,
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        obscureText: _showPassword,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: "Password",
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
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please enter your password";
                          }
                          return null;
                        },
                        controller: passwordController,
                      ),
                      const SizedBox(height: 15.0),
                      FormField<bool>(
                        builder: (state) {
                          return Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Checkbox(
                                      value: checkboxValue,
                                      onChanged: (value) {
                                        setState(() {
                                          checkboxValue = value!;
                                          state.didChange(value);
                                        });
                                      }),
                                  const Text(
                                    "I accept all terms and conditions.",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  state.errorText ?? '',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Theme.of(context).errorColor,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                        validator: (value) {
                          if (!checkboxValue) {
                            return 'You need to accept terms and conditions';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      // ignore: avoid_unnecessary_containers
                      Container(
                          margin: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                          child: ElevatedButton(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text(
                                  "Register".toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  registerUser();
                                }
                              })),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Have an account?'),
                            TextButton(
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage())),
                                child: const Text('Login')),
                          ],
                        ),
                      )
                    ]),
                  ),
                ],
              ))
        ])));
  }
}
