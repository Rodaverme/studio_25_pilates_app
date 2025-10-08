import 'package:dio/dio.dart';
import 'package:studio_25_pilates_app/config/dio/dio_client.dart';
import 'package:studio_25_pilates_app/domain/datasources/payment_datasource.dart';
import 'package:studio_25_pilates_app/domain/entities/payment.dart';
import 'package:studio_25_pilates_app/infrastructure/mappers/payments/payments_mapper.dart';
import 'package:studio_25_pilates_app/infrastructure/models/payments/payments_response.dart';

class PaymentDatasourceImpl extends PaymentDatasource {
  final Dio dio = DioClient.Dio_create();

  @override
  Future<List<Payment>> getAllPayments() async {
    try {
      final response = await dio.get('/api/client/payments');
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data;
        final List<Payment> payments = data
            .map(
              (json) => PaymentsMapper.paymentApiToEntity(
                PaymentResponse.fromJson(json),
              ),
            )
            .toList();

        print('Estos son los pagos  que existen ${payments.length}');
        return payments;
      }
      throw Exception('Error al obtner los  pagos');
    } on DioException catch (e) {
      throw Exception(
        'Error al obtener todos los pagos: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}
