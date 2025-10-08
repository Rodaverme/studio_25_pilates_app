// error_handler.dart
import 'package:dio/dio.dart';
import 'app_error.dart';

class ErrorHandler {
  static AppError handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          return AppError("⏳ La conexión tardó demasiado. Verifica tu internet.");
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          if (statusCode == 400) return AppError("Solicitud inválida. Revisa los datos ingresados.");
          if (statusCode == 401) return AppError("⚠️ Credenciales incorrectas. Intenta nuevamente.");
          if (statusCode == 403) return AppError("No tienes permisos para esta acción.");
          if (statusCode == 404) return AppError("Credenciales incorrectas. Intenta nuevamente.");
          if (statusCode == 500) return AppError("😔 El servidor tuvo un problema. Intenta más tarde.");
          return AppError(error.response?.data["message"] ?? "Error desconocido en el servidor.");
        case DioExceptionType.cancel:
          return AppError("La solicitud fue cancelada.");
        default:
          return AppError("No pudimos conectarnos. Revisa tu conexión a internet.");
      }
    } else {
      return AppError("Ocurrió un error inesperado. Intenta de nuevo.");
    }
  }
}
