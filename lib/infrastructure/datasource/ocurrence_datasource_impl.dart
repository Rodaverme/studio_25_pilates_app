import 'package:dio/dio.dart';
import 'package:studio_25_pilates_app/config/dio/dio_client.dart';
import 'package:studio_25_pilates_app/domain/datasources/ocurrence_datasouce.dart';
import 'package:studio_25_pilates_app/domain/entities/ocurrence.dart';
import 'package:studio_25_pilates_app/infrastructure/mappers/ocurrences/ocurrence_mapper.dart';
import 'package:studio_25_pilates_app/infrastructure/models/ocurrences/ocurrences_response.dart';

class OcurrenceDatasourceImpl extends OcurrenceDatasouce {
  final Dio dio = DioClient.Dio_create();
  String _formatDate(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}"
        "-${date.month.toString().padLeft(2, '0')}"
        "-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Future<List<Ocurrence>> getAllOcurrence(DateTime from, DateTime to) async {
    try {
      final response = await dio.get(
        '/api/occurrences',
        queryParameters: {"from": _formatDate(from), "to": _formatDate(to)},
      );

      if (response.statusCode == 200 && response.data != null) {
        final json = response.data;

        if (json is Map<String, dynamic> && json.containsKey('data')) {
          final List<dynamic> rawData = json['data'] ?? [];

          final occurrences = rawData
              .map((item) => OccurrenceMapper.toEntity(Datum.fromJson(item)))
              .toList();

          return occurrences;
        } else {
          throw Exception("El JSON no contiene 'data'");
        }
      }

      throw Exception(
        "Error al obtener ocurrencias: status ${response.statusCode}",
      );
    } on DioException catch (e) {
      print("❌ DioException: ${e.message}");
      print("❌ Response: ${e.response?.data}");
      rethrow; // Mantiene el error original
    } catch (e, stack) {
      print("❌ Error inesperado: $e");
      print("❌ Stack: $stack");
      rethrow;
    }
  }

  @override
  Future<List<Ocurrence>> getAllOcurrenceByDay(DateTime day) async {
    try {
      final allOcurrence = await getAllOcurrence(
        DateTime.now(),
        DateTime(2026, 10, 12),
      );

      final selectedDate = DateTime(day.year, day.month, day.day);

      final filterdOcurrences = allOcurrence.where((ocu) {
        final ocurrenceDate = DateTime(
          ocu.date.year,
          ocu.date.month,
          ocu.date.day,
        );
        return ocurrenceDate == selectedDate;
      }).toList();
      return filterdOcurrences;
    } on DioException catch (e) {
      throw Exception(
        "Error al obtener ocurrencias: ${e.response?.data ?? e.message}",
      );
    } catch (e) {
      throw Exception("Error inesperado en getAllOccurrences: $e");
    }
  }

  @override
  Future<List<Ocurrence>> getOcurrencesByClassId(
    int classId,
    String from,
    String to,
  ) {
    // TODO: implement getOcurrencesByClassId
    throw UnimplementedError();
  }

  @override
  Future<List<Ocurrence>> getOcurrencesByClassPlan(
    int planId,
    String from,
    String to,
  ) {
    // TODO: implement getOcurrencesByClassPlan
    throw UnimplementedError();
  }

  // @override
  // Future<PilatesClass> getClassesById(String id) async {
  //   try {
  //     final response = await dio.get('/api/classes/$id');

  //     if (response.statusCode == 200 && response.data != null) {
  //       // ✅ ahora parseamos como objeto
  //       final Map<String, dynamic> data = response.data as Map<String, dynamic>;
  //       final cls = ClassSessionResponse.fromJson(data);
  //       return ClassMapper.classApitoEntity(cls);
  //     }
  //     throw Exception('Error al obtener la clase por Id');
  //   } on DioException catch (e) {
  //     throw Exception(
  //       'Error al obtener la clase por id: ${e.response?.data ?? e.message}',
  //     );
  //   } catch (e) {
  //     throw Exception('Error inesperado: $e');
  //   }
  // }

  @override
  Future<Ocurrence> getOcurrencesById(int id) async {
    try {
      final response = await dio.get('/api/occurrences/$id');
      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> data = response.data as Map<String, dynamic>;
        final ocurrencias = Datum.fromJson(data);
        final ocurrence = OccurrenceMapper.toEntity(ocurrencias);
        return ocurrence;
      }
      throw Exception(
        "Error al obtener ocurrencia por Id: status ${response.statusCode}",
      );
    } on DioException catch (e) {
      throw Exception(
        'Error al obtener la Ocurrencia por id: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}
