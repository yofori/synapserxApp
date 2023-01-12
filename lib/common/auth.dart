import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:device_info/device_info.dart';
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
            connectTimeout: 5000,
            receiveTimeout: 3000,
          ),
        );

  final Dio _dio;

  Future<int> loginUser(String username, String password) async {
    try {
      log('Attempting login........');
      Response response = await _dio.post(
        '/user/login',
        data: {'username': username, 'password': password},
      );
      if (response.statusCode == 201) {
        await saveUserData(response, password);
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
          GlobalData.defaultAccount =
              (await storage.read(key: 'defaultAccount'))!;
          return 2; //authentication sucessful via local storage
        }
        return 0;
      } else {
        log(err.message);
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
            "Password reset instructions have been emailed to the email provided",
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
    List prescriberInstitutions = res.data['prescriberInstitutions'];
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
    GlobalData.useraccounts = prescriberInstitutions;
    //get the default account from which the prescriber prescribes from if it has been set. It will bypass if it is the firt time
    if (prescriberInstitutions.isNotEmpty) {
      var result = prescriberInstitutions
          .firstWhere((account) => account['defaultAccount'] == true);
      GlobalData.defaultAccount = result['_id'];
    } else {
      GlobalData.defaultAccount = '';
    }

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
    await storage.write(
        key: "defaultAccount", value: GlobalData.defaultAccount);
  }

  Future<void> updateFCMToken({required String fcmtoken}) async {
    String? deviceid = await _getId();
    try {
      Response response = await _dio.post(
        '/user/updatetoken/$fcmtoken',
        data: {
          "userid": GlobalData.prescriberid,
          "deviceid": deviceid,
          "platform": Platform.isIOS ? "ios" : "android",
        },
      );
      if (response.statusCode == 200) {
        log("fcmtoken updated");
      }
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      log(errorMessage);
    }
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
    return null;
  }
}
