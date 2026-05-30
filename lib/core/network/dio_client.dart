import 'package:dio/dio.dart';
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
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (isEnableApiLog) {
            talker.info('➡️ REQUEST: ${options.method} ${options.uri}');
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (isEnableApiLog) {
            talker.info(
              '✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}',
            );
          }
          handler.next(response);
        },
        onError: (error, handler) {
          if (isEnableApiLog) {
            talker.error(
              '❌ URL: ${error.requestOptions.uri}\n'
              '❌ STATUS: ${error.response?.statusCode}\n'
              '❌ REDIRECT TO: ${error.response?.headers['location']}\n'
              '❌ BODY: ${error.response?.data}',
            );
          }
          handler.next(error);
        },
      ),
    );
  }
}
