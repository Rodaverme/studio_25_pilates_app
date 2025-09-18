import 'package:dio/dio.dart';
import 'package:studio_25_pilates_app/config/dio/dio_client.dart';
import 'package:studio_25_pilates_app/domain/datasources/reservations_datasource.dart';
import 'package:studio_25_pilates_app/domain/entities/entities.dart';
import 'package:studio_25_pilates_app/infrastructure/mappers/reservation_mapper.dart';
import 'package:studio_25_pilates_app/infrastructure/models/reservation/reservation_response.dart';

class ReservationDatasourceImpl extends ReservationsDatasource {
  final Dio dio = DioClient.Dio_create();
  @override
  Future<void> createReservation(
    int ocurrenceId,
    String paymentMethod,
    int cardId,
  ) async {
    try {
      final response = await dio.post(
        '/api/reservations',
        data: {
          "occurrence_id": ocurrenceId,
          "payment_method": paymentMethod,
          "card_id": cardId,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Reserva Exitosa');
        return;
      }
      throw Exception('Error al hacer la reservera');
    } on DioException catch (e) {
      throw Exception(
        'Error al obtener la reserva: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<List<Reservation>> getResevation() async {
    try {
      final response = await dio.get('/api/reservations');
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data;
        final List<Reservation> reserved = data
            .map(
              (json) => ReservationMapper.toEntity(
                ReservationResponse.fromJson(json),
              ),
            )
            .toList();

        print('Estos son las  que existen ${reserved.length}');
        return reserved;
      }
      throw Exception('Error al obtner las reservas');
    } on DioException catch (e) {
      throw Exception(
        'Error al obtener todas las reservas: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}
