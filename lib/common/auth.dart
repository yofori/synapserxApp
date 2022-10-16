import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:synapserx_prescriber/common/dio_exception.dart';
import 'package:synapserx_prescriber/common/service.dart';

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
      return err.response;
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

  Future<dynamic> resetPasswordRequest(String email) async {
    try {
      Response response = await _dio.post(
        '/user/resetpasswordrequest',
        data: {'email': email},
      );
      return response.data;
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      log(errorMessage);
    }
    return null;
  }
}
