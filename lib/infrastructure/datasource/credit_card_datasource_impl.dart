import 'package:dio/dio.dart';
import 'package:studio_25_pilates_app/config/dio/dio_client.dart';
import 'package:studio_25_pilates_app/domain/datasources/credit_card_datasource.dart';
import 'package:studio_25_pilates_app/domain/entities/credit_card.dart';
import 'package:studio_25_pilates_app/infrastructure/mappers/payments/credit_card_mapper.dart';
import 'package:studio_25_pilates_app/infrastructure/models/payments/credit_card_response.dart';

class CreditCardDatasourceImpl extends CreditCardDatasource {
  final Dio dio = DioClient.Dio_create();
  @override
  Future<List<CreditCard>> getMycreditCard() async {
    try {
      final response = await dio.get('/api/client/cards');

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data;

        final List<CreditCard> card = data
            .map(
              (json) => CreditCardMapper.cardApitoEntity(
                CreditCardResponse.fromJson(json),
              ),
            )
            .toList();
        return card;
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
  Future<void> saveCreditCard(
    String number,
    String cvc,
    String expMonth,
    String expYear,
    String cardHolder,
    String acceptToken,
    String acceptPersonalAuth,
  ) async {
    try {
      final response = await dio.post(
        '/api/cards',
        data: {
          "number": number,
          "cvc": cvc,
          "exp_month": expMonth,
          "exp_year": expYear,
          "card_holder": cardHolder,
          "acceptance_token": acceptToken,
          "accept_personal_auth": acceptPersonalAuth,
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
}
