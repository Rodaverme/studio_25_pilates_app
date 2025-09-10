import 'package:dio/dio.dart';
import 'package:studio_25_pilates_app/config/dio/dio_client.dart';
import 'package:studio_25_pilates_app/domain/datasources/notifications_datasource.dart';

class NotificationsDatasourceImpl extends NotificationsDatasource {
  final Dio dio = DioClient.Dio_create();
  @override
  Future<void> sendToken(String token) async {
   try {
      final response = await dio.post(
        '/api/client/device-token',
        data: {
          "device_token": token,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Envio del token exitoso');
        return;
      }
      throw Exception('Error al enviar el token');
    } on DioException catch (e) {
      throw Exception(
        'Error al enviar el token: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
  
}