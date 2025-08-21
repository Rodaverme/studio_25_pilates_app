import 'package:studio_25_pilates_app/domain/entities/pilates_class.dart';

abstract class ClassRespository {
  Future<List<PilatesClass>> getAllClasses();
  Future<List<PilatesClass>> getClassesByDay(DateTime day);
  Future<PilatesClass> getClassesById(String id);
}
