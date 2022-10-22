import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:synapserx_prescriber/common/auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
// ignore: library_private_types_in_public_api
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  final DioClient _dioClient = DioClient();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: (const Text('SynapseRx - Reset Password'))),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Forgot your Password?",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Enter your email address below to\nrecieve password reset instructions",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 25, 40, 25),
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'email address',
                    hintText: "enter your registered email",
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    // ignore: prefer_is_not_empty
                    if ((val!.isEmpty) ||
                        !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                            .hasMatch(val)) {
                      return "Enter a valid email address";
                    }
                    return null;
                  },
                  focusNode: FocusNode(),
                  textInputAction: TextInputAction.done,
                ),
              ),
              ElevatedButton(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                      child: Text(
                        "Reset Password".toUpperCase(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _dioClient
                          .resetPasswordRequest(emailController.text);
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
