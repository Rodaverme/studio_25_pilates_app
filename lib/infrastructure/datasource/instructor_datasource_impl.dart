import 'package:dio/dio.dart';
import 'package:studio_25_pilates_app/config/dio/dio_client.dart';
import 'package:studio_25_pilates_app/domain/datasources/instructor_datasource.dart';
import 'package:studio_25_pilates_app/domain/entities/instructor.dart';
import 'package:studio_25_pilates_app/infrastructure/mappers/instructor_mapper.dart';
import 'package:studio_25_pilates_app/infrastructure/models/class/instructor/instructor_response.dart';

class InstructorDatasourceImpl extends InstructorDatasource {
  final Dio dio = DioClient.Dio_create();
  @override
  Future<Instructor> getAInstructorById(String id) async {
    try {
      final response = await dio.get('/api/instructors/$id');

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data;

        final instructor = data
            .map((e) => InstructorResponse.fromJson(e))
            .toList();

        final inst = InstructorMapper.instructorApitoEntity(instructor.first);
        print('Un instructor es  ${inst.name}');

        return inst;
      }
      throw Exception('Error al obtener el instructor');
    } on DioException catch (e) {
      throw Exception(
        'Error al obtener mi instructor: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<List<Instructor>> getAllInstructor() async {
    try {
      final response = await dio.get('/api/instructors');
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data;
        final List<Instructor> instructors = data
            .map(
              (json) => InstructorMapper.instructorApitoEntity(
                InstructorResponse.fromJson(json),
              ),
            )
            .toList();

        print('Estos son los instructores que existen ${instructors.length}');
        return instructors;
      }
      throw Exception('Error al obtner los');
    } on DioException catch (e) {
      throw Exception(
        'Error al obtener todos los planes: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}
