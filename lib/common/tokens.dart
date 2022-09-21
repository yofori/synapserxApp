import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:synapserx_prescriber/common/service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Tokens extends Interceptor {
  static const storage = FlutterSecureStorage();
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers['Authorization'] = GlobalData.accessToken;
    return handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if ((err.response?.statusCode == 401 &&
        err.response?.data['message'] == "Not authorized")) {
      debugPrint('expired token');
      if (GlobalData.refreshToken != '') {
        bool tokenrefreshed = await refreshToken();
        if (tokenrefreshed) {
          return handler.resolve(await retry(err.requestOptions));
        } else {
          return handler.next(err);
        }
      }
    }
    return handler.next(err);
  }

  Future<bool> refreshToken() async {
    var options = BaseOptions(
      baseUrl: 'http://10.0.2.2:3000/api',
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );

    Dio dio = Dio(options);

    final refreshToken = GlobalData.refreshToken;
    try {
      final response = await dio.post('/user/refreshtoken', data: {
        'username': GlobalData.username,
        'refreshToken': refreshToken
      });

      if (response.statusCode == 201) {
        // successfully got the new access token
        GlobalData.accessToken = response.data['token'];
        GlobalData.refreshToken = response.data['refreshtoken'];
        // now write to secure storage
        await storage.write(key: "token", value: GlobalData.accessToken);
        await storage.write(
            key: "refreshtoken", value: GlobalData.refreshToken);
        return true;
      }
    } on DioError catch (err) {
      if (err.response!.statusCode == 401) {
        debugPrint("Looks like the refresh token as expired too");
      }
    }
    return false;
  }

  Future<Response<dynamic>> retry(RequestOptions requestOptions) async {
    debugPrint("Retrying......"); //
    final options = Options(
      method: requestOptions.method,
      headers: {"Authorization": GlobalData.accessToken},
    );
    return Dio().request<dynamic>(requestOptions.baseUrl + requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }
}
