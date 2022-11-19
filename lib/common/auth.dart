import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:synapserx_prescriber/common/dio_exception.dart';
import 'package:synapserx_prescriber/common/service.dart';
import 'package:synapserx_prescriber/main.dart';

class DioClient {
  DioClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: GlobalData.baseUrl,
            connectTimeout: 9000,
            receiveTimeout: 6000,
          ),
        );

  final Dio _dio;

  Future<int> loginUser(String username, String password) async {
    try {
      Response response = await _dio.post(
        '/user/login',
        data: {'username': username, 'password': password},
      );
      if (response.statusCode == 201) {
        saveUserData(response, password);
        return 1;
      }
    } on DioError catch (err) {
      if (err.type == DioErrorType.connectTimeout) {
        const storage = FlutterSecureStorage();
        final String? storedusername = await storage.read(key: 'username');
        final String? storedpassword = await storage.read(key: 'password');
        //implement offline authentication with save username and password here
        if ((username == storedusername) & (password == storedpassword)) {
          GlobalData.fullname = (await storage.read(key: 'fullname'))!;
          GlobalData.surname = (await storage.read(key: 'surname'))!;
          GlobalData.mdcregno = (await storage.read(key: 'mdcregno'))!;
          GlobalData.firstname = (await storage.read(key: 'firstname'))!;
          GlobalData.prescriberid = (await storage.read(key: 'prescriberid'))!;
          GlobalData.accessToken = (await storage.read(key: 'token'))!;
          return 2; //authentication sucessful via local storage
        }
        return 0;
      } else {
        return 3; //authentication via local storage fails
      }
    }
    return 0; // authentication failed
  }

  Future<dynamic> logoutUser() async {
    try {
      Response response = await _dio.get(
        '/user/logout',
      );
      return response.data;
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      log(errorMessage);
    }
    return null;
  }

  Future<void> resetPasswordRequest(String email) async {
    try {
      Response response = await _dio.post(
        '/user/resetpasswordrequest',
        data: {'email': email},
      );

      if (response.statusCode == 200) {
        scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Password reset instructions have been emailed to the email provided'",
          ),
        ));
        Navigator.pushReplacementNamed(navigatorKey.currentContext!, '/');
      }
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "Error: $errorMessage",
        ),
      ));
    }
  }

  Future<bool> changePassword(String password) async {
    try {
      Response response = await _dio.post('/user/inapppasswordchange',
          data: {'username': GlobalData.username, 'password': password},
          options: Options(
            headers: {"Authorization": GlobalData.accessToken},
          ));
      if (response.statusCode == 200) {
        return true;
      }
    } on DioError {
      return false;
    }
    return false;
  }

  saveUserData(Response res, String password) async {
    String accessToken = res.data['token'];
    String refreshToken = res.data['refreshtoken'];
    String username = res.data['username'];
    GlobalData.accessToken = accessToken;
    GlobalData.refreshToken = refreshToken;
    GlobalData.username = username;
    GlobalData.password = password;
    String fullname = res.data['firstname'] + ' ' + res.data['surname'];
    String firstname = res.data['firstname'];
    String surname = res.data['surname'];
    String mdcregno = res.data['mdcregno'];
    String prescriberid = res.data['id'];
    GlobalData.fullname = fullname;
    GlobalData.surname = surname;
    GlobalData.mdcregno = mdcregno;
    GlobalData.firstname = firstname;
    GlobalData.prescriberid = prescriberid;
    const storage = FlutterSecureStorage();
    await storage.write(key: "token", value: accessToken);
    await storage.write(key: "refreshtoken", value: refreshToken);
    await storage.write(key: "fullname", value: fullname);
    await storage.write(key: "mdcregno", value: mdcregno);
    await storage.write(key: "username", value: username);
    await storage.write(key: "password", value: password);
    await storage.write(key: "firstname", value: firstname);
    await storage.write(key: "surname", value: surname);
    await storage.write(key: "prescriberid", value: prescriberid);
  }
}
