import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class NetworkService {
  //final url = 'https://vtsa.empat.tech/';
  final _prodUrl = 'https://toyvalley.io/';
  final _devUrl = 'http://192.168.227.134/';

  final _prodSecretKey = 'UEjfM5v67oe0EATZ';
  final _devSecretKey = 'PZSnrHjk7NAReJB2';

  String get url => _devUrl;
  String get secretKey => _devSecretKey;

  Dio? _api;
  String? jwt;
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Dio? getApiClient() {
    if (_api == null) {
      _api = Dio();
      _api!.interceptors.clear();
      _api!.interceptors.add(getInterceptor());
      _api!.interceptors.add(PrettyDioLogger(
        requestBody: true,
        compact: false,
        maxWidth: 200,
      ));
      _api!.options.baseUrl = url;
      return _api;
    } else {
      return _api;
    }
  }

  Future<String?> getJwt() async {
    if (jwt != null) {
      return jwt;
    } else {
      jwt = await secureStorage.read(key: "jwt");
      return jwt;
    }
  }

  Future saveAuthSession(String token) async {
    jwt = token;
    secureStorage.write(key: 'jwt', value: token);
  }

  Future deleteAuthSession() async {
    await secureStorage.delete(key: "jwt");
  }

  Future checkIfAuthSessionExists() async {
    return secureStorage.containsKey(key: 'jwt');
  }

  Future checkIfFirstLaunch() async {
    final val = await secureStorage.containsKey(key: "firstLaunch");
    if (val) {
      return false;
    } else {
      secureStorage.write(key: 'firstLaunch', value: "true");
      return true;
    }
  }

  String _getAppVersion() {
    if (Platform.isIOS) {
      return "ios-1.0.0";
    } else if (Platform.isAndroid) {
      return "android-1.0.0";
    }
    return "";
  }

  InterceptorsWrapper getInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, requestHandler) async {
        await getJwt();
        options.headers['Accept-Language'] = 'en';
        options.headers['App-Version'] = _getAppVersion();
        options.headers['Authorization'] = "Bearer $jwt";
        return requestHandler.next(options);
      },
    );
  }
}
