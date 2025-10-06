import 'package:dio/dio.dart';
import 'package:studio_25_pilates_app/config/dio/dio_client.dart';
import 'package:studio_25_pilates_app/domain/datasources/stats_datasource.dart';
import 'package:studio_25_pilates_app/domain/entities/stats.dart';
import 'package:studio_25_pilates_app/infrastructure/mappers/stats/stast_mapper.dart';
import 'package:studio_25_pilates_app/infrastructure/models/stats/stats_response.dart';

class StatsDatasourceImpl extends StatsDatasource {
  final Dio dio = DioClient.Dio_create();

  String _formatDate(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Future<Stats> getStats(DateTime from, DateTime to) async {
    try {
      final response = await dio.get(
        '/api/client/usage-stats',
        queryParameters: {"from": _formatDate(from), "to": _formatDate(to)},
      );

      if (response.statusCode == 200 && response.data != null) {
        final json = response.data;

        if (json is Map<String, dynamic>) {
          // ✅ Parseamos directamente la respuesta
          final statsResponse = StastResponse.fromJson(json);
          final stats = StastMapper.statsApiToEntity(statsResponse);
          return stats;
        } else {
          throw Exception(
            "❌ Estructura de respuesta inesperada (no es JSON de tipo mapa).",
          );
        }
      }

      throw Exception(
        "❌ Error al obtener estadísticas: status ${response.statusCode}",
      );
    } on DioException catch (e) {
      print("❌ DioException: ${e.message}");
      print("❌ Response: ${e.response?.data}");
      rethrow;
    } catch (e, stack) {
      print("❌ Error inesperado: $e");
      print("❌ Stack: $stack");
      rethrow;
    }
  }
}
