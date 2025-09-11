import 'package:studio_25_pilates_app/domain/entities/pilates_class.dart';
import 'package:studio_25_pilates_app/domain/repositories/class_respository.dart';
import 'package:studio_25_pilates_app/infrastructure/infrastructure.dart';

class ClassRespositoryImpl extends ClassRespository {
  final ClassDatasourceImpl datasource;

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

  @override
  Future<List<PilatesClass>> getClassesByPlan(int id) {
    return datasource.getClassesByPlan(id);
  }

  @override
  Future<PilatesClass> getClassReserved() {
    return datasource.getClassReserved();
  }
}
