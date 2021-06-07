import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

abstract class BaseRequest{
  String? baseURL;
  Dio? dio;
  // static final BaseRequest _request = BaseRequest._internal();
  // BaseRequest._internal();
  BaseRequest init(String url, BaseRequest request) {
    request.baseURL = url;
    request.dio = new Dio();
    (request.dio!.httpClientAdapter as DefaultHttpClientAdapter)
        .onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    request.dio!.options.connectTimeout = 30000;
    request.dio!.options.receiveTimeout = 3000;
    return request;
  }

  // factory BaseRequest() => _request;
  

}