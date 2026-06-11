import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:my_app/core/constants/api_const.dart';
import 'package:my_app/data/api/global_data.dart';

class DioClient {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConst.baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  DioClient() {
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          logPrint: (object) => talker.info(object.toString()),
        ),
      );
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (isEnableApiLog) {
            talker.info(
              'REQUEST: ${options.method} ${options.uri}\n'
              'HEADERS: ${options.headers}\n'
              'BODY: ${options.data}',
            );
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (isEnableApiLog) {
            talker.info(
              'RESPONSE: ${response.statusCode} ${response.requestOptions.uri}\n'
              'BODY: ${response.data}',
            );
          }
          handler.next(response);
        },
        onError: (error, handler) {
          if (isEnableApiLog) {
            talker.error(
              'URL: ${error.requestOptions.uri}\n'
              'METHOD: ${error.requestOptions.method}\n'
              'HEADERS: ${error.requestOptions.headers}\n'
              'REQUEST BODY: ${error.requestOptions.data}\n'
              'STATUS: ${error.response?.statusCode}\n'
              'RESPONSE HEADERS: ${error.response?.headers}\n'
              'REDIRECT TO: ${error.response?.headers['location']}\n'
              'RESPONSE BODY: ${error.response?.data}',
            );
          }
          handler.next(error);
        },
      ),
    );
  }
}
