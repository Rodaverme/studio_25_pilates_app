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
  ) async {
    try {
      final response = await dio.post(
        '/api/cards',
        data: {
          "name": "4242424242424242",
          "document": "1312312312",
          "email": "asdl@adasd.com", //opcional
          "phone": "113223232", //opcional
          "reservation_id": 1,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Creacion Exitosa');
        return;
      }
      throw Exception('Error al obtener la tarjeta de credito');
    } on DioException catch (e) {
      throw Exception(
        'Error al obtener mi tarjeta de credito: ${e.response?.data ?? e.message}',
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
