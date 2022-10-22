import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

  Future loginUser(String username, String password) async {
    try {
      Response response = await _dio.post(
        '/user/login',
        data: {'username': username, 'password': password},
      );
      return response;
    } on DioError catch (err) {
      if (err.type == DioErrorType.connectTimeout) {
        log(err.message);
      } else {
        return err.response;
      }
    }
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
}
