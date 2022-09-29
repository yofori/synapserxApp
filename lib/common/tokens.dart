import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:synapserx_prescriber/common/service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:synapserx_prescriber/main.dart';

class Tokens extends Interceptor {
  static const storage = FlutterSecureStorage();
  BuildContext context = navigatorKey.currentContext!;
  TextEditingController textFieldController = TextEditingController();
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
          //navigatorKey.currentState!
          //return handler.next(err);
          bool authenticated = false;
          debugPrint('Showing Authentication Dialog');
          await authenticateDialog().then((value) {
            debugPrint('the return value is:  $value');
            authenticated = value;
          });
          debugPrint('the authenticated value is $authenticated');
          // Future<bool> authenticated = authenticateDialog();
          if (authenticated) {
            debugPrint('Reloading................................');
            return handler.resolve(await retry(err.requestOptions));
          }
        }

        return handler.next(err);
      }
    }
  }

  Future<bool> refreshToken() async {
    var options = BaseOptions(
      baseUrl: GlobalData.baseUrl,
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
        return false;
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

  Future<bool> authenticateDialog() async {
    final formKey = GlobalKey<FormState>();
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Confirm Password',
          textAlign: TextAlign.center,
        ),
        content: Form(
          key: formKey,
          child: TextFormField(
            validator: (value) {
              if (value != GlobalData.password) {
                return 'Password entered is incorrect';
              }
              return null;
            },
            obscureText: true,
            //textAlign: TextAlign.center,
            onChanged: (value) {},
            controller: textFieldController,
            decoration: const InputDecoration(
              hintText: "Enter your password",
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.green,
              ),
            ),
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.red,
                  side: const BorderSide(
                    width: 1.5,
                    color: Colors.red,
                  )),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, false);
              }),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  //if (textFieldController.text == GlobalData.password) {
                  login(textFieldController.text).then((value) {
                    Navigator.pop(context, value);
                  });
                } else {}
              },
              child: const Text('Confirm'))
        ],
      ),
    );
  }

  Future<bool> login(String password) async {
    Response res = await Dio().post<dynamic>('${GlobalData.baseUrl}/user/login',
        data: {'username': GlobalData.username, 'password': password});
    if (res.statusCode == 201) {
      GlobalData.accessToken = res.data['token'];
      GlobalData.refreshToken = res.data['refreshtoken'];
      debugPrint('authentication successful');
      return true;
    } else {
      debugPrint('authentication failed');
      return false;
    }
  }
}
