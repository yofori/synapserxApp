import 'package:dio/dio.dart';
import 'package:synapserx_prescriber/common/dio_exception.dart';
import 'package:synapserx_prescriber/common/logging.dart';
import 'package:synapserx_prescriber/models/associations.dart';
import 'package:synapserx_prescriber/models/prescription.dart';
import 'package:synapserx_prescriber/models/user.dart';

class DioClient {
  DioClient()
      : _dio = Dio(
          BaseOptions(
            //baseUrl: 'https://api.synapserx.com/api',
            //baseUrl: 'https://192.168.98.116/api',
            baseUrl: 'http://10.0.2.2:3000/api',
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
      //print('login: $e');
    }
  }

  Future<Prescription?> getPrescription(String prescriptionId) async {
    try {
      Response response = await _dio.get(
        '/prescription/$prescriptionId',
      );
      return Prescription.fromJson(response.data);
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      throw errorMessage;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<Associations>> getAssociations(String token) async {
    try {
      _dio.options.headers['Authorization'] = token;
      Response response = await _dio.get(
        '/user/listassociations',
      );
      //print(response.data);
      return (response.data as List)
          .map((x) => Associations.fromJson(x))
          .toList();
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      throw errorMessage;
    } catch (e) {
      print(e);
      throw e.toString();
    }
  }

  Future<dynamic> addAssociation(
      {required String token, required String patientid}) async {
    _dio.options.headers['Authorization'] = token;
    //print(patientid);
    try {
      Response response = await _dio.post(
        '/user/createassociation',
        data: {'patientuid': patientid},
      );
      if (response.statusCode == 201) {
        return response.data;
      }
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      return {'ErrorCode': 401, 'Message': errorMessage};
    }
  }

  Future<List<Prescription>> getPxRx(
      {required String patientuid, required String token}) async {
    try {
      _dio.options.headers['Authorization'] = token;
      Response response = await _dio
          .get('/prescription/getpatientprescriptions?pxId=$patientuid');
      return (response.data as List)
          .map((x) => Prescription.fromJson(x))
          .toList();
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      if (err.response!.statusCode == 404) {
        return [];
      }
      throw errorMessage;
    }
  }
}
