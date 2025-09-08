import 'package:dio/dio.dart';
import 'package:studio_25_pilates_app/config/dio/dio_client.dart';
import 'package:studio_25_pilates_app/domain/datasources/transactions_datasource.dart';

class TransactionsDatasourceImpl extends TransactionsDatasource {
  final Dio dio = DioClient.Dio_create();
  @override
  Future<void> doTransaction(
    String type,
    String typeId,
    int amount,
    String currency,
    String method,
    String paymentSourceId,
  ) async {
    try {
      final response = await dio.post(
        '/api/payments/transactions',
        data: {
          "type": type,
          "type_id": typeId,
          "amount": amount, // Monto a pagar
          "currency": currency, // Moneda
          "method": method,
          "payment_source_id": paymentSourceId,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Transacion Exitosa');
        print(response);
        return;
      }
      throw Exception('Error al hacer la transaccion');
    } on DioException catch (e) {
      throw Exception(
        'Error al hacer la transaccion: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('Error inesperado en la transaccion : $e');
    }
  }
}
