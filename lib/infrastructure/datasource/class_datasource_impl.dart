import 'package:studio_25_pilates_app/domain/clases.dart';
import 'package:studio_25_pilates_app/domain/datasources/class_datasource.dart';
import 'package:studio_25_pilates_app/domain/entities/pilates_class.dart';

class ClassDatasourceImpl extends ClassDatasource {
  @override
  Future<List<PilatesClass>> getAllClasses() {
    // TODO: implement getAllClasses
    throw UnimplementedError();
  }

  @override
  Future<List<PilatesClass>> getClassesByDay(DateTime day) async {
    //TODO REMPLAZAR CON LA INFORMACION DE LA API , IGU
    await Future.delayed(const Duration(milliseconds: 500));
    final selectedDate = DateTime(day.year, day.month, day.day);

    final filteredClasses = listClass.where((c) {
      final classDate = DateTime(
        c.fechaHora.year,
        c.fechaHora.month,
        c.fechaHora.day,
      );
      return classDate == selectedDate;
    }).toList();

    return filteredClasses;
  }

  @override
  Future<PilatesClass> getClassesById(String id) async {
    await Future.delayed(Duration(milliseconds: 500));

    final classResult = listClass.firstWhere(
      (clase) => clase.id == id,
      orElse: () => throw Exception('Clase con id $id no encontrada'),
    );
    return classResult;
  }
}
