import 'package:dio/dio.dart';
import 'package:studio_25_pilates_app/presentation/services/Auth/auth_interceptor.dart';

class DioClient {
  static Dio_create( ) {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://app.estudio25pilates.com',
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    dio.interceptors.add(AuthInterceptor());
    return dio;
  }

}
