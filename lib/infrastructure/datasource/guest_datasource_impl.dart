import 'package:dio/dio.dart';
import 'package:studio_25_pilates_app/config/dio/dio_client.dart';
import 'package:studio_25_pilates_app/domain/datasources/guest_datasource.dart';
import 'package:studio_25_pilates_app/infrastructure/models/guest/guest_response.dart';

class GuestDatasourceImpl extends GuestDatasource {
  final Dio dio = DioClient.Dio_create();
  @override
  Future<void> createGuest(
    String name,
    String document,
    String? email,
    String? phone,
    int reservationId
  ) async {
    try {
      final response = await dio.post(
        '/api/guests',
        data: {
          "name": name,
          "document": document,
          "email": email ,
          "phone": phone, //opcional
          "reservation_id": reservationId,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Creacion Exitosa');
        return;
      }
      throw Exception('Error al obtener al crear la invitacion');
    } on DioException catch (e) {
      throw Exception(
        'Error en la creacion de la invitacion: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<List<GuestResponse>> getAllGuest() {
    // TODO: implement getAllGuest
    throw UnimplementedError();
  }

  @override
  Future<List<GuestResponse>> getAllGuestById(int id) {
    // TODO: implement getAllGuestById
    throw UnimplementedError();
  }
}
