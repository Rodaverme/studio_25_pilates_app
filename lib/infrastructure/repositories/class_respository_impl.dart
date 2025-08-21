import 'package:studio_25_pilates_app/domain/datasources/class_datasource.dart';
import 'package:studio_25_pilates_app/domain/entities/pilates_class.dart';
import 'package:studio_25_pilates_app/domain/repositories/class_respository.dart';

class ClassRespositoryImpl extends ClassRespository {
  final ClassDatasource datasource;

  ClassRespositoryImpl({required this.datasource});
  @override
  Future<List<PilatesClass>> getAllClasses() {
    return datasource.getAllClasses();
  }

  @override
  Future<List<PilatesClass>> getClassesByDay(DateTime day) {
    return datasource.getClassesByDay(day);
  }

  @override
  Future<PilatesClass> getClassesById(String id) {
    return datasource.getClassesById(id);
  }
}
