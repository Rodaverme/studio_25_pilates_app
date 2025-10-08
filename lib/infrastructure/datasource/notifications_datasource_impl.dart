import 'package:dio/dio.dart';
import 'package:studio_25_pilates_app/config/dio/dio_client.dart';
import 'package:studio_25_pilates_app/domain/datasources/notifications_datasource.dart';
import 'package:studio_25_pilates_app/domain/entities/push_message.dart';
import 'package:studio_25_pilates_app/infrastructure/mappers/notifications/notifications_mapper.dart';
import 'package:studio_25_pilates_app/infrastructure/models/notifications/notifications_response.dart';

class NotificationsDatasourceImpl extends NotificationsDatasource {
  final Dio dio = DioClient.Dio_create();
  @override
  Future<void> sendToken(String token) async {
    try {
      final response = await dio.post(
        '/api/client/device-token',
        data: {"device_token": token},
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

  @override
  Future<List<PushMessage>> getAllNotification() async {
    try {
      final response = await dio.get('/api/client/notifications');
      print(response);

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data;
        final List<PushMessage> messages = data
            .map(
              (json) => NotificationsMapper.notificationApitoEntity(
                NotificationsResponse.fromJson(json),
              ),
            )
            .toList();

        print('Estos son las notificaciones que existen ${messages.length}');
        return messages;
      }
      throw Exception('Error al obtner las notificacionee');
    } on DioException catch (e) {
      throw Exception(
        'Error al obtener todos las notificaciones: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<void> markAsRead(int pushMessageId) async {
    try {
      final response = await dio.post('/api/notifications/$pushMessageId/read');
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Envio de la notificacion leida exitosa');
        return;
      }
      throw Exception('Error al leer la notificacion ');
    } on DioException catch (e) {
      throw Exception(
        'Error al enviar el token: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}
