import 'package:dio/dio.dart';
import 'package:studio_25_pilates_app/config/dio/dio_client.dart';
import 'package:studio_25_pilates_app/domain/datasources/merchants_datasource.dart';
import 'package:studio_25_pilates_app/domain/entities/merchants.dart';
import 'package:studio_25_pilates_app/infrastructure/mappers/payments/merchants_mapper.dart';
import 'package:studio_25_pilates_app/infrastructure/models/payments/merchants_response.dart';

class MerchantsDatasourceImpl extends MerchantsDatasource {
  final Dio dio = DioClient.Dio_create();

  @override
  Future<Merchants> getTokenPermalink() async {
   try {
      final response = await dio.get('/api/payments/merchants');

      if (response.statusCode == 200 && response.data != null) {
        // ✅ Aquí no es lista, sino un Map
        final Map<String, dynamic> data = response.data;

        final merchantsResponse = MerchantsResponse.fromJson(data);

        // ✅ Pasamos el objeto a entidad con el mapper
        final merch = MerchantsMapper.merchantsApiToEntity(merchantsResponse);

      

          print('token 1 ${merch.presignedAcceptance}, token2 ${merch.presignedPersonalDataAuth}');

        return merch;
      }
      throw Exception('Error al obtener los tokens y permalinks');
    } on DioException catch (e) {
      throw Exception(
        'Error al obtener los tokens: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
  }

  // eyJhbGciOiJIUzI1NiJ9.eyJjb250cmFjdF9pZCI6NDcyLCJwZXJtYWxpbmsiOiJodHRwczovL3dvbXBpLmNvbS9hc3NldHMvZG93bmxvYWRibGUvcmVnbGFtZW50by1Vc3Vhcmlvcy1Db2xvbWJpYS5wZGYiLCJmaWxlX2hhc2giOiJkYzJkNGUzMDVlNGQzNmFhYjhjYzU3N2I1YTY5Nzg1MSIsImppdCI6IjE3NTcxMTA0NTAtMzI3NzQiLCJlbWFpbCI6IiIsImV4cCI6MTc1NzExNDA1MH0.Fm1X8oqie2OQJbPdA515lye2A8We5lq5wTQAWR_CQ4E
// eyJhbGciOiJIUzI1NiJ9.eyJjb250cmFjdF9pZCI6NDM5LCJwZXJtYWxpbmsiOiJodHRwczovL3dvbXBpLmNvbS9hc3NldHMvZG93bmxvYWRibGUvYXV0b3JpemFjaW9uLXRyYXRhbWllbnRvLWRhdG9zLXBlcnNvbmFsZXMucGRmIiwiZmlsZV9oYXNoIjoiNTE2ODYzZjA3NzZlZWY3NjBkNGI5OWFiMWJlZjRjNzgiLCJqaXQiOiIxNzU3MTEwNDUwLTY2Nzc1IiwiZW1haWwiOiIifQ.vNHGqPMrt1s_9r3CHNTnE3DaaA8ASrJotPFNh46BG2A