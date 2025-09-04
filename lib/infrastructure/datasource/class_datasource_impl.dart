import 'package:dio/dio.dart';
import 'package:studio_25_pilates_app/config/dio/dio_client.dart';
import 'package:studio_25_pilates_app/domain/datasources/class_datasource.dart';
import 'package:studio_25_pilates_app/domain/entities/pilates_class.dart';
import 'package:studio_25_pilates_app/infrastructure/mappers/class/class_mapper.dart';
import 'package:studio_25_pilates_app/infrastructure/models/class/class_session_response.dart';

class ClassDatasourceImpl extends ClassDatasource {
  final Dio dio = DioClient.Dio_create();
  @override
  Future<List<PilatesClass>> getAllClasses() async {
    try {
      final response = await dio.get('/api/classes');
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data;
        final List<PilatesClass> classes = data
            .map(
              (json) => ClassMapper.classApitoEntity(
                ClassSessionResponse.fromJson(json),
              ),
            )
            .toList();

        return classes;
      }
      throw Exception('error a obtener las clases');
    } on DioException catch (e) {
      throw Exception(
        'Error al obtener todas las clases  ${e.response?.data ?? e.message} ',
      );
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<List<PilatesClass>> getClassesByDay(DateTime day) async {
    try {
      // Traemos todas las clases usando la función ya implementada
      final allClasses = await getAllClasses();

      // Normalizamos la fecha seleccionada
      final selectedDate = DateTime(day.year, day.month, day.day);

      // Filtramos las clases que coincidan en fecha
      final filteredClasses = allClasses.where((c) {
        final classDate = DateTime(
          c.fechaHora.year,
          c.fechaHora.month,
          c.fechaHora.day,
        );
        return classDate == selectedDate;
      }).toList();

      return filteredClasses;
    } catch (e) {
      throw Exception('Error en getClassesByDay: $e');
    }
  }

  @override
  Future<PilatesClass> getClassesById(String id) async {
    try {
      final response = await dio.get('/api/classes/$id');

      if (response.statusCode == 200 && response.data != null) {
        // ✅ ahora parseamos como objeto
        final Map<String, dynamic> data = response.data as Map<String, dynamic>;
        final cls = ClassSessionResponse.fromJson(data);
        return ClassMapper.classApitoEntity(cls);
      }
      throw Exception('Error al obtener la clase por Id');
    } on DioException catch (e) {
      throw Exception(
        'Error al obtener la clase por id: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}
