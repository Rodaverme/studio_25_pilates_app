import 'package:studio_25_pilates_app/domain/entities/pilates_class.dart';

abstract class ClassDatasource {
  Future<List<PilatesClass>> getAllClasses();
  // Future<List<PilatesClass>> getClassesByDay(DateTime day);
  Future<PilatesClass> getClassesById(String id);
  // Future<List<PilatesClass>> getClassesByPlan(int id);
  Future<List<PilatesClass>> getClassReserved();
}
