import 'package:dio/dio.dart';
import 'package:studio_25_pilates_app/config/dio/dio_client.dart';
import 'package:studio_25_pilates_app/domain/datasources/class_datasource.dart';
import 'package:studio_25_pilates_app/domain/entities/pilates_class.dart';
import 'package:studio_25_pilates_app/infrastructure/mappers/class/class_mapper.dart';
import 'package:studio_25_pilates_app/infrastructure/models/class/class_session_response.dart';
import 'package:studio_25_pilates_app/presentation/helpers/app_error.dart';
import 'package:studio_25_pilates_app/presentation/helpers/error_handler.dart';

// 👇 Importamos manejo de errores centralizado

class ClassDatasourceImpl extends ClassDatasource {
  final Dio dio = DioClient.Dio_create();

  @override
  Future<List<PilatesClass>> getAllClasses() async {
    try {
      final response = await dio.get('/api/classes');

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data['data']; // 👈 lista de clases

        final List<PilatesClass> classes = data
            .map(
              (json) => ClassMapper.classApitoEntity(
                ClassSessionResponse.fromJson(json),
              ),
            )
            .toList();

        return classes;
      }

      throw AppError("No se pudieron obtener las clases.");
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  @override
  Future<PilatesClass> getClassesById(String id) async {
    try {
      final response = await dio.get('/api/classes/$id');

      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> data = response.data as Map<String, dynamic>;
        final cls = ClassSessionResponse.fromJson(data);
        return ClassMapper.classApitoEntity(cls);
      }

      throw AppError("No se pudo obtener la clase solicitada.");
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  @override
  Future<List<PilatesClass>> getClassReserved() {
    // TODO: implementar con el mismo patrón de errores
    throw UnimplementedError();
  }
}
