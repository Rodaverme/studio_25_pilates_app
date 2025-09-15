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
        final List<dynamic> data =
            response.data['data']; // 👈 aquí extraes la lista

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

  // @override
  // Future<List<PilatesClass>> getClassesByDay(DateTime day) async {
  //   try {
  //     // Traemos todas las clases usando la función ya implementada
  //     final allClasses = await getAllClasses();

  //     // Normalizamos la fecha seleccionada
  //     final selectedDate = DateTime(day.year, day.month, day.day);

  //     // Filtramos las clases que coincidan en fecha
  //     final filteredClasses = allClasses.where((c) {
  //       final classDate = DateTime(c.date.year, c.date.month, c.date.day);
  //       return classDate == selectedDate;
  //     }).toList();

  //     return filteredClasses;
  //   } catch (e) {
  //     throw Exception('Error en getClassesByDay: $e');
  //   }
  // }

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

  // @override
  // Future<List<PilatesClass>> getClassesByPlan(int id) async {
  //   try {
  //     final response = await dio.get('/api/classes/by-plan/$id');
  //     if (response.statusCode == 200 && response.data != null) {
  //       final rawData = response.data['classes']; // 👈 aquí está la lista

  //       if (rawData == null) return [];

  //       final List<dynamic> data = rawData as List<dynamic>;

  //       final List<PilatesClass> classes = data
  //           .map(
  //             (json) => ClassMapper.classApitoEntity(
  //               ClassSessionResponse.fromJson(json as Map<String, dynamic>),
  //             ),
  //           )
  //           .toList();

  //       return classes;
  //     }
  //     throw Exception('Error al obtener las clases');
  //   } on DioException catch (e) {
  //     throw Exception(
  //       'Error al obtener todas las clases  ${e.response?.data ?? e.message} ',
  //     );
  //   } catch (e) {
  //     throw Exception('Error inesperado: $e');
  //   }
  // }

  @override
  Future<List<PilatesClass>> getClassReserved() {
    // TODO: implement getClassReserved
    throw UnimplementedError();
  }

  //   @override
  //   Future<List<PilatesClass>> getClassReserved() async {
  //     try {
  //       final response = await dio.get('/api/reservations');
  //       print("Reservas crudas: ${response.data}");
  //       if (response.statusCode == 200 && response.data != null) {
  //         final rawData = response.data; // 👈 aquí está la lista

  //         final List<dynamic> data = rawData as List<dynamic>;

  //         final List<PilatesClass> classes = data
  //             .map(
  //               (json) => ReservedClassMapper.resevartionToClassEntity(
  //                 ReservationResponse.fromJson(json),
  //               ),
  //             )
  //             .toList();

  //         return classes;
  //       }
  //       throw Exception('Error al obtener las clases');
  //     } on DioException catch (e) {
  //       throw Exception(
  //         'Error al obtener todas las clases  ${e.response?.data ?? e.message} ',
  //       );
  //     } catch (e) {
  //       throw Exception('Error inesperado: $e');
  //     }
  //   }
  // }
}
