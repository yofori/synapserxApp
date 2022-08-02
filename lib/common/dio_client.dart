import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:synapserx_prescriber/common/dio_exception.dart';
import 'package:synapserx_prescriber/common/logging.dart';
import 'package:synapserx_prescriber/models/prescription.dart';
import 'package:synapserx_prescriber/models/user.dart';

class DioClient {
  DioClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'http://127.0.0.1:3000/api',
            connectTimeout: 5000,
            receiveTimeout: 3000,
          ),
        )..interceptors.add(Logging());

  final Dio _dio;

  // Fetches an user based on the given `id`.

  //create a new user
  Future<dynamic> createUser({required User user}) async {
    try {
      Response response = await _dio.post(
        '/user/register',
        data: user.toJson(),
      );
      return response.data;
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      throw errorMessage;
    }
  }

  Future<dynamic> loginUser(String username, String password) async {
    try {
      Response response = await _dio.post(
        '/user/login',
        data: {'username': username, 'password': password},
      );

      return response.data;
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      if (err.response?.statusCode == 400 || err.response?.statusCode == 401) {
        return {'ErrorCode': 401, 'Message': errorMessage};
      }
    } catch (e) {
      print('login: $e');
    }
  }

  Future<Prescription?> getPrescription(String prescriptionId) async {
    try {
      _dio.options.headers['Cache-Control'] = 'no-cache';
      Response response = await _dio.get(
        '/prescription/$prescriptionId',
      );
      return Prescription.fromJson(response.data);
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      throw errorMessage;
    } catch (e) {
      print(e);
      throw e.toString();
    }
  }
}
