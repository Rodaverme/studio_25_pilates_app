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
  void onError(DioException err, ErrorInterceptorHandler handler) async{
    if (err.response?.statusCode == 401) {
      print('Token invalido o sesión expirada');
      await TokenService.deleleteToken();
      
    }
    super.onError(err, handler);
  }
}
