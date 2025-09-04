
import 'package:dio/dio.dart';
import 'package:studio_25_pilates_app/config/dio/dio_client.dart';
import 'package:studio_25_pilates_app/domain/datasources/credit_card_datasource.dart';
import 'package:studio_25_pilates_app/domain/entities/credit_card.dart';
import 'package:studio_25_pilates_app/infrastructure/mappers/payments/credit_card_mapper.dart';
import 'package:studio_25_pilates_app/infrastructure/models/payments/credit_card_response.dart';

class CreditCardDatasourceImpl extends CreditCardDatasource {
  final Dio dio = DioClient.Dio_create();
  @override
  Future<CreditCard> getMycreditCard()async{
   
     try {
      final response = await dio.get('/api/cards');

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data;

        final card = data
            .map((e) => CreditCardResponse.fromJson(e))
            .toList();

        final creditCard = CreditCardMapper.cardApitoEntity(card.first);
        print('Tu tarjeta de credito  es  ${creditCard.brand}');

        return creditCard;
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