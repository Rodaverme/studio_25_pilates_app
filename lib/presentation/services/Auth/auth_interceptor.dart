import 'package:dio/dio.dart';

import 'package:studio_25_pilates_app/presentation/services/Auth/token_service.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await TokenService.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      //TODO REDIRIGIR AL LOGIN SI EL TOKEN ESPIRO O YA CERRO SESION
      print('Token invalido o sesión expirada');
    }
    super.onError(err, handler);
  }
}
