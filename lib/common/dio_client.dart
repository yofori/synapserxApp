import 'dart:developer';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:synapserx_prescriber/common/dio_exception.dart';
import 'package:synapserx_prescriber/common/logging.dart';
import 'package:synapserx_prescriber/common/service.dart';
import 'package:synapserx_prescriber/common/tokens.dart';
import 'package:synapserx_prescriber/models/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:synapserx_prescriber/models/useraccounts.dart';

class DioClient {
  DioClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: GlobalData.baseUrl,
            connectTimeout: 5000,
            receiveTimeout: 3000,
          ),
        )..interceptors.addAll([Logging(), Tokens()]);

  final Dio _dio;

  static const storage = FlutterSecureStorage();

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

  Future<Prescription?> getPrescription(String prescriptionId) async {
    try {
      Response response = await _dio.get(
        '/prescription/$prescriptionId',
      );
      if (response.statusCode == 200) {
        return Prescription.fromJson(response.data);
      }
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  Future<Patient?> getPatientDetails(String patientId) async {
    try {
      Response response = await _dio.get(
        '/patient/$patientId',
      );
      if (response.statusCode == 200) {
        return Patient.fromJson(response.data);
      }
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  Future<List<Associations>> getAssociations(String token) async {
    try {
      //_dio.options.headers['Authorization'] = token;
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
      if (kDebugMode) {
        print(e);
      }
      throw e.toString();
    }
  }

  Future<dynamic> addAssociation({required String patientid}) async {
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

  Future<List<Prescription>> getPxRx(String patientuid) async {
    try {
      Response response = await _dio
          .get('/prescription/getpatientprescriptions?pxId=$patientuid');
      return (response.data as List)
          .map((x) => Prescription.fromJson(x))
          .toList();
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      throw errorMessage;
    }
  }

  Future<List<Prescription>> getPrescriberRx(String prescriberid) async {
    try {
      Response response = await _dio.get(
          '/prescription/getprescriberprescriptions?prescriberid=$prescriberid');
      return (response.data as List)
          .map((x) => Prescription.fromJson(x))
          .toList();
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      throw errorMessage;
    }
  }

  Future<List<UserAccount>> getUserAccounts(String prescriberid) async {
    try {
      Response response =
          await _dio.get('/user/listinstitutions/$prescriberid');
      return (response.data as List)
          .map((x) => UserAccount.fromJson(x))
          .toList();
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      throw errorMessage;
    }
  }

  Future<dynamic> createPrescription(
      {required String patientID,
      required List medicines,
      required String pxSurname,
      required String pxFirstname,
      required int pxAge,
      required String pxDOB,
      required bool isRegistered,
      required String prescriberAccount,
      String? pxEmail,
      String? pxTelephone,
      required bool isRenewal,
      String? prescriptionBeingRenewed,
      required String pxGender}) async {
    try {
      Response response = await _dio.post(
        '/prescription/create',
        data: {
          'patientID': patientID,
          'medications': medicines,
          'pxSurname': pxSurname,
          'pxFirstname': pxFirstname,
          'pxAge': pxAge,
          'pxDOB': pxDOB,
          'pxEmail': pxEmail,
          'pxTelephone': pxTelephone,
          'pxgender': pxGender,
          'isPxRegistered': isRegistered,
          'prescriberInstitution': prescriberAccount,
          'isRenewal': isRenewal,
          'prescriptionBeingRenewed':
              isRenewal ? prescriptionBeingRenewed : null,
        },
      );
      if (response.statusCode == 201) {
        return response.data;
      }
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      throw errorMessage;
    }
    return null;
  }

  Future<dynamic> deletePrescription({required String prescriptionID}) async {
    try {
      Response response =
          await _dio.put('/prescription/delete/$prescriptionID');
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch (err) {
      final errorMessage = DioException.fromDioError(err).toString();
      throw errorMessage;
    }
  }

  Future<dynamic> updatePrescription(
      {required String prescriptionID, required data}) async {
    try {
      Response response =
          await _dio.put('/prescription/update/$prescriptionID', data: data);
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch (err) {
      if (err.error.statusCode == 404) {
        return null;
      }
    }
    return null;
  }

  Future<dynamic> renewPrescription({
    required String prescriptionID,
  }) async {
    try {
      Response response =
          await _dio.post('/prescription/renew/$prescriptionID');
      if (response.statusCode == 201) {
        return response.data;
      }
    } on DioError catch (err) {
      if (err.error.statusCode == 404) {
        return null;
      }
    }
    return null;
  }

  Future<dynamic> addUserAccount({required UserAccount useraccount}) async {
    try {
      Response response = await _dio.post(
          '/user/addinstitution/${GlobalData.prescriberid}',
          data: useraccount.toJson());
      if (response.statusCode == 201) {
        return response.data;
      }
    } on DioError catch (err) {
      log(err.message);
      return null;
    }
    return null;
  }

  Future<bool> deleteUserAccount(String accountid) async {
    try {
      Response response = await _dio.post(
        '/user/deleteinstitution/${GlobalData.prescriberid}/$accountid',
      );
      if (response.statusCode == 202) {
        return true;
      }
    } on DioError catch (err) {
      log(err.message);
      return false;
    }
    return false;
  }

  Future<bool> updateUserAccount(String accountid,
      {required UserAccount useraccount}) async {
    try {
      Response response = await _dio.post(
          '/user/updateinstitution/${GlobalData.prescriberid}/$accountid',
          data: useraccount.toJson());
      if (response.statusCode == 202) {
        return true;
      }
    } on DioError catch (err) {
      log(err.message);
      return false;
    }
    return false;
  }

  Future<bool> makeUserAccountDefault(String accountid) async {
    try {
      Response response = await _dio.post(
        '/user/makeinstitutiondefault/${GlobalData.prescriberid}/$accountid',
      );
      if (response.statusCode == 202) {
        return true;
      }
    } on DioError catch (err) {
      log(err.message);
      return false;
    }
    return false;
  }
}
